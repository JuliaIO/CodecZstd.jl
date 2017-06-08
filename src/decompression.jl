# Decompression Codec
# ===================

struct ZstdDecompression <: TranscodingStreams.Codec
    dstream::DStream
end

"""
    ZstdDecompression()

Create a new zstd decompression codec.
"""
function ZstdDecompression()
    return ZstdDecompression(DStream())
end

const ZstdDecompressionStream{S} = TranscodingStream{ZstdDecompression,S}

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
    finalizer(codec.dstream, safefree!)
end

function TranscodingStreams.finalize(codec::ZstdDecompression)
    safefree!(codec.dstream)
end

function safefree!(dstream::DStream)
    if dstream.ptr != C_NULL
        code = free!(dstream)
        if iserror(code)
            zstderror(dstream, code)
        end
        dstream.ptr = C_NULL
    end
    return
end

function TranscodingStreams.process(codec::ZstdDecompression, input::Memory, output::Memory)
    dstream = codec.dstream
    dstream.ibuffer.src = input.ptr
    dstream.ibuffer.size = input.size
    dstream.ibuffer.pos = 0
    dstream.obuffer.dst = output.ptr
    dstream.obuffer.size = output.size
    dstream.obuffer.pos = 0
    code = decompress!(dstream)
    if iserror(code)
        error("zstd error")
    else
        Δin = Int(dstream.ibuffer.pos)
        Δout = Int(dstream.obuffer.pos)
        return Δin, Δout, code == 0 ? :end : :ok
    end
end
