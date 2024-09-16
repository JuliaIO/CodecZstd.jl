# Compressor Codec
# ================

struct ZstdCompressor <: TranscodingStreams.Codec
    cstream::CStream
    endOp::LibZstd.ZSTD_EndDirective
    parameters::Dict{LibZstd.ZSTD_cParameter, Cint}
    function ZstdCompressor(cstream, level, endOp=:continue; kwargs...)
        _parameters = Dict{LibZstd.ZSTD_cParameter, Cint}(LibZstd.ZSTD_c_compressionLevel => level)
        for (k,v) in kwargs
            _parameters[_symbols_to_cParameters[k]] = v
        end
        return new(cstream, endOp, _parameters)
    end
end

function Base.show(io::IO, codec::ZstdCompressor)
    parameters_string = ""
    for (k,v) in codec.parameters
        if k != LibZstd.ZSTD_c_compressionLevel
            parameters_string *= string(", ", replace(string(k), "ZSTD_c_" => ""), "=", v)
        end
    end
    if codec.endOp == LibZstd.ZSTD_e_end
        print(io, "ZstdFrameCompressor(level=$(codec.level)$parameters_string)")
    else
        print(io, summary(codec), "(level=$(codec.level)$parameters_string)")
    end
end

# Same as the zstd command line tool (v1.2.0).
const DEFAULT_COMPRESSION_LEVEL = 3

"""
    ZstdCompressor(;level=$(DEFAULT_COMPRESSION_LEVEL))

Create a new zstd compression codec.

Arguments
---------
- `level`: compression level (1..$(MAX_CLEVEL))
"""
function ZstdCompressor(;level::Integer=DEFAULT_COMPRESSION_LEVEL, kwargs...)
    if !(1 ≤ level ≤ MAX_CLEVEL)
        throw(ArgumentError("level must be within 1..$(MAX_CLEVEL)"))
    end
    return ZstdCompressor(CStream(), level; kwargs...)
end

const _symbols_to_cParameters = Dict(
    :compressionLevel => LibZstd.ZSTD_c_compressionLevel,
    :windowLog => LibZstd.ZSTD_c_windowLog,
    :hashLog => LibZstd.ZSTD_c_hashLog,
    :chainLog => LibZstd.ZSTD_c_chainLog,
    :searchLog => LibZstd.ZSTD_c_searchLog,
    :minMatch => LibZstd.ZSTD_c_minMatch,
    :targetLength => LibZstd.ZSTD_c_targetLength,
    :strategy => LibZstd.ZSTD_c_strategy,
    :enableLongDistanceMatching => LibZstd.ZSTD_c_enableLongDistanceMatching,
    :ldmHashLog => LibZstd.ZSTD_c_ldmHashLog,
    :ldmMinMatch => LibZstd.ZSTD_c_ldmMinMatch,
    :ldmBucketSizeLog => LibZstd.ZSTD_c_ldmBucketSizeLog,
    :ldmHashRateLog => LibZstd.ZSTD_c_ldmHashRateLog,
    :contentSizeFlag => LibZstd.ZSTD_c_contentSizeFlag,
    :checksumFlag => LibZstd.ZSTD_c_checksumFlag,
    :dictIDFlag => LibZstd.ZSTD_c_dictIDFlag,
    :nbWorkers => LibZstd.ZSTD_c_nbWorkers,
    :jobSize => LibZstd.ZSTD_c_jobSize,
    :overlapLog => LibZstd.ZSTD_c_overlapLog
)

function Base.propertynames(compressor::ZstdCompressor)
    return (fieldnames(ZstdCompressor)..., keys(_symbols_to_cParameters)...)
end

function Base.getproperty(compressor::ZstdCompressor, name::Symbol)
    if name == :level
        return Int(get(compressor.parameters, LibZstd.ZSTD_c_compressionLevel, DEFAULT_COMPRESSION_LEVEL))
    elseif haskey(_symbols_to_cParameters, name)
        return compressor.parameters[_symbols_to_cParameters[name]]
    else
        return getfield(compressor, name)
    end
end

function Base.setproperty!(compressor::ZstdCompressor, name::Symbol, value)
    if name == :level
        compressor.parameters[LibZstd.ZSTD_c_compressionLevel] = value
    elseif haskey(_symbols_to_cParameters, name)
        compressor.parameters[_symbols_to_cParameters[name]] = value
    else
        return setfield!(compressor, name, value)
    end
    return nothing
end

"""
   ZstdFrameCompressor(;level=$(DEFAULT_COMPRESSION_LEVEL))

Create a new zstd compression codec that reads the available input and then
closes the frame, encoding the decompressed size of that frame.

Arguments
---------
- `level`: compression level (1..$(MAX_CLEVEL))
"""
function ZstdFrameCompressor(;level::Integer=DEFAULT_COMPRESSION_LEVEL)
    if !(1 ≤ level ≤ MAX_CLEVEL)
        throw(ArgumentError("level must be within 1..$(MAX_CLEVEL)"))
    end
    return ZstdCompressor(CStream(), level, :end)
end
# pretend that ZstdFrameCompressor is a compressor type
function TranscodingStreams.transcode(C::typeof(ZstdFrameCompressor), args...)
    codec = C()
    initialize(codec)
    try
        return transcode(codec, args...)
    finally
        finalize(codec)
    end
end

const ZstdCompressorStream{S} = TranscodingStream{ZstdCompressor,S} where S<:IO

"""
    ZstdCompressorStream(stream::IO; kwargs...)

Create a new zstd compression stream (see `ZstdCompressor` for `kwargs`).
"""
function ZstdCompressorStream(stream::IO; kwargs...)
    x, y = splitkwargs(kwargs, (:level,))
    return TranscodingStream(ZstdCompressor(;x...), stream; y...)
end


# Methods
# -------

function TranscodingStreams.initialize(codec::ZstdCompressor)
    code = initialize!(codec.cstream, codec.parameters)
    if iserror(code)
        zstderror(codec.cstream, code)
    end
    reset!(codec.cstream.ibuffer)
    reset!(codec.cstream.obuffer)
    return
end

function TranscodingStreams.finalize(codec::ZstdCompressor)
    if codec.cstream.ptr != C_NULL
        code = free!(codec.cstream)
        if iserror(code)
            zstderror(codec.cstream, code)
        end
        codec.cstream.ptr = C_NULL
    end
    reset!(codec.cstream.ibuffer)
    reset!(codec.cstream.obuffer)
    return
end

function TranscodingStreams.startproc(codec::ZstdCompressor, mode::Symbol, error::Error)
    code = reset!(codec.cstream, 0 #=unknown source size=#)
    if iserror(code)
        error[] = ErrorException("zstd error")
        return :error
    end
    return :ok
end

function TranscodingStreams.process(codec::ZstdCompressor, input::Memory, output::Memory, error::Error)
    cstream = codec.cstream
    ibuffer_starting_pos = UInt(0)
    if codec.endOp == LibZstd.ZSTD_e_end &&
       cstream.ibuffer.size != cstream.ibuffer.pos
            # While saving a frame, the prior process run did not finish writing the frame.
            # A positive code indicates the need for additional output buffer space.
            # Re-run with the same cstream.ibuffer.size as pledged for the frame,
            # otherwise a "Src size is incorrect" error will occur.

            # For the current frame, cstream.ibuffer.size - cstream.ibuffer.pos
            # must reflect the remaining data. Thus neither size or pos can change.
            # Store the starting pos since it will be non-zero.
            ibuffer_starting_pos = cstream.ibuffer.pos

            # Set the pointer relative to input.ptr such that
            # cstream.ibuffer.src + cstream.ibuffer.pos == input.ptr
            cstream.ibuffer.src = input.ptr - cstream.ibuffer.pos
    else
        cstream.ibuffer.src = input.ptr
        cstream.ibuffer.size = input.size
        cstream.ibuffer.pos = 0
    end
    cstream.obuffer.dst = output.ptr
    cstream.obuffer.size = output.size
    cstream.obuffer.pos = 0
    if input.size == 0
        code = finish!(cstream)
    else
        code = compress!(cstream; endOp = codec.endOp)
    end
    Δin = Int(cstream.ibuffer.pos - ibuffer_starting_pos)
    Δout = Int(cstream.obuffer.pos)
    if iserror(code)
        ptr = LibZstd.ZSTD_getErrorName(code)
        error[] = ErrorException("zstd error: " * unsafe_string(ptr))
        return Δin, Δout, :error
    else
        return Δin, Δout, input.size == 0 && code == 0 ? :end : :ok
    end
end
