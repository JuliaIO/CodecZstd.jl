# Frame Compressor Codec
# ======================

struct ZstdFrameCompressor <: TranscodingStreams.Codec
    cstream::CStream
    level::Int
end

function Base.show(io::IO, codec::ZstdFrameCompressor)
    print(io, summary(codec), "(level=$(codec.level))")
end

# See compressor.jl for DEFAULT_COMPRESSION_LEVEL

"""
    ZstdFrameCompressor(;level=$(DEFAULT_COMPRESSION_LEVEL))

Create a new zstd compression codec using the non-streaming API.
This is uses `ZSTD_compress2`. This compressor expects to have the
entire input buffer to be compressed available and stores the
decompressed length in the frame header.

Arguments
---------
- `level`: compression level ($(MIN_CLEVEL)..$(MAX_CLEVEL))
"""
function ZstdFrameCompressor(;level::Integer=DEFAULT_COMPRESSION_LEVEL)
    if !(MIN_CLEVEL ≤ level ≤ MAX_CLEVEL)
        throw(ArgumentError("level must be within $(MIN_CLEVEL)..$(MAX_CLEVEL)"))
    end
    return ZstdFrameCompressor(CStream(), level)
end

const ZstdFrameCompressorStream{S} = TranscodingStream{ZstdFrameCompressor,S} where S<:IO

"""
    ZstdFrameCompressorStream(stream::IO; kwargs...)

Create a new zstd compression stream (see `ZstdFrameCompressor` for `kwargs`).
"""
function ZstdFrameCompressorStream(stream::IO; kwargs...)
    x, y = splitkwargs(kwargs, (:level,))
    return TranscodingStream(ZstdFrameCompressor(;x...), stream; y...)
end


# Methods
# -------

function TranscodingStreams.initialize(codec::ZstdFrameCompressor)
    code = initialize!(codec.cstream, codec.level)
    if iserror(code)
        throw(ZstdError(code))
    end
    return
end

function TranscodingStreams.finalize(codec::ZstdFrameCompressor)
    if codec.cstream.ptr != C_NULL
        code = free!(codec.cstream)
        if iserror(code)
            throw(ZstdError(code))
        end
        codec.cstream.ptr = C_NULL
    end
    return
end

function TranscodingStreams.expectedsize(codec::ZstdFrameCompressor, input::Memory)
    code = compressed_size_bound(input.size)
    if iserror(code)
        throw(ZstdError(code))
    end
    return Int(code)
end

function TranscodingStreams.startproc(codec::ZstdFrameCompressor, mode::Symbol, error::Error)
    code = reset!(codec.cstream, 0 #=unknown source size=#)
    if iserror(code)
        error[] = ZstdError(code)
        return :error
    end
    return :ok
end

function TranscodingStreams.process(codec::ZstdFrameCompressor, input::Memory, output::Memory, error::Error)
    cstream = codec.cstream
    cstream.ibuffer.src = input.ptr
    cstream.ibuffer.size = input.size
    cstream.ibuffer.pos = 0
    cstream.obuffer.dst = output.ptr
    cstream.obuffer.size = output.size
    cstream.obuffer.pos = 0
    code = frameCompress!(cstream)
    if iserror(code)
        error[] = ZstdError(code)
        return 0, 0, :error
    else
        return Int(input.size), Int(code), :end
    end
end
