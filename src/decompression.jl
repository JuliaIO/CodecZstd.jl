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
    dstream = DStream()
    initialize!(dstream)
    return ZstdDecompression(dstream)
end

const ZstdDecompressionStream{S} = TranscodingStream{ZstdDecompression,S} where S<:IO

"""
    ZstdDecompressionStream(stream::IO)

Create a new zstd decompression stream.
"""
function ZstdDecompressionStream(stream::IO)
    return TranscodingStream(ZstdDecompression(), stream)
end

function TranscodingStreams.startproc(codec::ZstdDecompression, ::Symbol)
    # TODO: need to reset codec?
    return :ok
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

function TranscodingStreams.finalize(codec::ZstdDecompression)
    code = free!(codec.dstream)
    if iserror(code)
        error("zstd error")
    end
    return
end
