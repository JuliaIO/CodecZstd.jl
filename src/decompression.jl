# Decompressor Codec
# ==================

struct ZstdDecompressor <: TranscodingStreams.Codec
    dstream::DStream
end

function Base.show(io::IO, codec::ZstdDecompressor)
    print(io, summary(codec), "()")
end

"""
    ZstdDecompressor()

Create a new zstd decompression codec.
"""
function ZstdDecompressor()
    return ZstdDecompressor(DStream())
end

const ZstdDecompressorStream{S} = TranscodingStream{ZstdDecompressor,S} where S<:IO

"""
    ZstdDecompressorStream(stream::IO; kwargs...)

Create a new zstd decompression stream (`kwargs` are passed to `TranscodingStream`).
"""
function ZstdDecompressorStream(stream::IO; kwargs...)
    return TranscodingStream(ZstdDecompressor(), stream; kwargs...)
end


# Methods
# -------

function TranscodingStreams.finalize(codec::ZstdDecompressor)
    if codec.dstream.ptr != C_NULL
        # This should never fail
        @assert !iserror(free!(codec.dstream))
        codec.dstream.ptr = C_NULL
    end
    return
end

function TranscodingStreams.startproc(codec::ZstdDecompressor, mode::Symbol, err::Error)
    if codec.dstream.ptr == C_NULL
        codec.dstream.ptr = LibZstd.ZSTD_createDCtx()
        if codec.dstream.ptr == C_NULL
            throw(OutOfMemoryError())
        end
        # TODO Allow setting other parameters here.
    end
    code = reset!(codec.dstream)
    if iserror(code)
        err[] = ErrorException("zstd initialization error")
        return :error
    end
    return :ok
end

function TranscodingStreams.process(codec::ZstdDecompressor, input::Memory, output::Memory, err::Error)
    if codec.dstream.ptr == C_NULL
        error("startproc must be called before process")
    end
    dstream = codec.dstream
    dstream.ibuffer.src = input.ptr
    dstream.ibuffer.size = input.size
    dstream.ibuffer.pos = 0
    dstream.obuffer.dst = output.ptr
    dstream.obuffer.size = output.size
    dstream.obuffer.pos = 0
    code = decompress!(dstream)
    Δin = Int(dstream.ibuffer.pos)
    Δout = Int(dstream.obuffer.pos)
    if iserror(code)
        if error_code(code) == Integer(LibZstd.ZSTD_error_memory_allocation)
            throw(OutOfMemoryError())
        end
        err[] = ErrorException("zstd decompression error: " * error_name(code))
        return Δin, Δout, :error
    else
        if code == 0
            return Δin, Δout, :end
        elseif input.size == 0 && code > 0
            err[] = ErrorException("zstd frame truncated. Expected at least $(code) more bytes")
            return Δin, Δout, :error
        else
            return Δin, Δout, :ok
        end
    end
end

function TranscodingStreams.expectedsize(codec::ZstdDecompressor, input::Memory)
    ret = find_decompressed_size(input.ptr, input.size)
    if ret == ZSTD_CONTENTSIZE_ERROR
        # something is bad, but we ignore it here
        return Int(input.size)
    elseif ret == ZSTD_CONTENTSIZE_UNKNOWN
        # random guess
        return Int(input.size * 2)
    else
        # exact size
        return Int(ret)
    end
end
