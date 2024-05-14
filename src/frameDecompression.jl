# Decompressor Codec
# ==================

struct ZstdFrameDecompressor <: TranscodingStreams.Codec
    dstream::DStream
end

function Base.show(io::IO, codec::ZstdFrameDecompressor)
    print(io, summary(codec), "()")
end

"""
    ZstdFrameDecompressor()

Create a new zstd decompression codec.
This decompressor uses the non-streaming API, expecting a known length, via `ZSTD_decompressDCtx`
"""
function ZstdFrameDecompressor()
    return ZstdFrameDecompressor(DStream())
end

const ZstdFrameDecompressorStream{S} = TranscodingStream{ZstdFrameDecompressor,S} where S<:IO

"""
    ZstdFrameDecompressorStream(stream::IO; kwargs...)

Create a new zstd decompression stream (`kwargs` are passed to `TranscodingStream`).
"""
function ZstdFrameDecompressorStream(stream::IO; kwargs...)
    return TranscodingStream(ZstdFrameDecompressor(), stream; kwargs...)
end


# Methods
# -------

function TranscodingStreams.initialize(codec::ZstdFrameDecompressor)
    code = initialize!(codec.dstream)
    if iserror(code)
        throw(ZstdError(code))
    end
    return
end

function TranscodingStreams.finalize(codec::ZstdFrameDecompressor)
    if codec.dstream.ptr != C_NULL
        code = free!(codec.dstream)
        if iserror(code)
            throw(ZstdError(code))
        end
        codec.dstream.ptr = C_NULL
    end
    return
end

function TranscodingStreams.startproc(codec::ZstdFrameDecompressor, mode::Symbol, error::Error)
    code = reset!(codec.dstream)
    if iserror(code)
        error[] = ZstdError(code)
        return :error
    end
    return :ok
end

function TranscodingStreams.process(codec::ZstdFrameDecompressor, input::Memory, output::Memory, error::Error)
    dstream = codec.dstream
    dstream.ibuffer.src = input.ptr
    dstream.ibuffer.size = input.size
    dstream.ibuffer.pos = 0
    dstream.obuffer.dst = output.ptr
    dstream.obuffer.size = output.size
    dstream.obuffer.pos = 0
    code = frameDecompress!(dstream)
    if iserror(code)
        error[] = ZstdError(code)
        return 0, 0, :error
    else
        return Int(input.size), Int(code), :end
    end
end

function TranscodingStreams.expectedsize(codec::ZstdFrameDecompressor, input::Memory)
    ret = find_decompressed_size(input.ptr, input.size)
    if ret == ZSTD_CONTENTSIZE_ERROR
        throw(ZstdError())
    elseif ret == ZSTD_CONTENTSIZE_UNKNOWN
        return Int(decompressed_size_bound(input.ptr, input.size))
    else
        # exact size
        return Int(ret)
    end
end
