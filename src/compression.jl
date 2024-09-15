# Compressor Codec
# ================

struct ZstdCompressor <: TranscodingStreams.Codec
    cstream::CStream
    level::Int
    endOp::LibZstd.ZSTD_EndDirective

    # Unexported inner constructor of ZstdCompressor
    global function private_ZstdCompressor(level::Int, endOp::LibZstd.ZSTD_EndDirective)
        local cstream = CStream()
        local code = initialize!(cstream, level)
        if iserror(code)
            zstderror(cstream, code)
        end
        new(cstream, level, endOp)
    end
end

function Base.show(io::IO, codec::ZstdCompressor)
    if codec.endOp == LibZstd.ZSTD_e_end
        print(io, "ZstdFrameCompressor(level=$(codec.level))")
    else
        print(io, summary(codec), "(level=$(codec.level))")
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
function ZstdCompressor(;level::Integer=DEFAULT_COMPRESSION_LEVEL)
    if !(1 ≤ level ≤ MAX_CLEVEL)
        throw(ArgumentError("level must be within 1..$(MAX_CLEVEL)"))
    end
    return private_ZstdCompressor(Int(level), LibZstd.ZSTD_e_continue)
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
    return private_ZstdCompressor(Int(level), LibZstd.ZSTD_e_end)
end
# pretend that ZstdFrameCompressor is a compressor type
function TranscodingStreams.transcode(C::typeof(ZstdFrameCompressor), args...)
    transcode(C(), args...)
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

function TranscodingStreams.finalize(codec::ZstdCompressor)
    cstream = codec.cstream
    p = @atomicswap cstream.ptr = C_NULL
    # no need to check if p is already C_NULL 
    # because ZSTD_freeCStream will handle that.
    LibZstd.ZSTD_freeCStream(p)
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
