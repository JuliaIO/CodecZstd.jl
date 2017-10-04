# Decompression Codec
# ===================

struct ZstdDecompression <: TranscodingStreams.Codec
    dstream::DStream
end

function Base.show(io::IO, codec::ZstdDecompression)
    print(io, summary(codec), "()")
end

"""
    ZstdDecompression()

Create a new zstd decompression codec.
"""
function ZstdDecompression()
    return ZstdDecompression(DStream())
end

const ZstdDecompressionStream{S} = TranscodingStream{ZstdDecompression,S} where S<:IO

"""
    ZstdDecompressionStream(stream::IO)

Create a new zstd decompression stream.
"""
function ZstdDecompressionStream(stream::IO)
    return TranscodingStream(ZstdDecompression(), stream)
end


# Methods
# -------

function TranscodingStreams.initialize(codec::ZstdDecompression)
    code = initialize!(codec.dstream)
    if iserror(code)
        zstderror(codec.dstream, code)
    end
    return
end

function TranscodingStreams.finalize(codec::ZstdDecompression)
    if codec.dstream.ptr != C_NULL
        code = free!(codec.dstream)
        if iserror(code)
            zstderror(codec.dstream, code)
        end
        codec.dstream.ptr = C_NULL
    end
    return
end

function TranscodingStreams.startproc(codec::ZstdDecompression, mode::Symbol, error::Error)
    code = reset!(codec.dstream)
    if iserror(code)
        error[] = ErrorException("zstd error")
        return :error
    end
    return :ok
end

function TranscodingStreams.process(codec::ZstdDecompression, input::Memory, output::Memory, error::Error)
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
        error[] = ErrorException("zstd error")
        return Δin, Δout, :error
    else
        return Δin, Δout, code == 0 ? :end : :ok
    end
end
