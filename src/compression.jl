# Compression Codec
# =================

struct ZstdCompression <: TranscodingStreams.Codec
    cstream::CStream
    level::Int
end

# Same as the zstd command line tool (v1.2.0).
const DEFAULT_COMPRESSION_LEVEL = 3

"""
    ZstdCompression(;level=$(DEFAULT_COMPRESSION_LEVEL))

Create a new zstd compression codec.
"""
function ZstdCompression(;level::Integer=DEFAULT_COMPRESSION_LEVEL)
    return ZstdCompression(CStream(), level)
end

const ZstdCompressionStream{S} = TranscodingStream{ZstdCompression,S}

"""
    ZstdCompressionStream(stream::IO)

Create a new zstd compression stream.
"""
function ZstdCompressionStream(stream::IO)
    return TranscodingStream(ZstdCompression(), stream)
end


# Methods
# -------

function TranscodingStreams.initialize(codec::ZstdCompression)
    code = initialize!(codec.cstream, codec.level)
    if iserror(code)
        zstderror(codec.cstream, code)
    end
    finalizer(codec.cstream, safefree!)
end

function TranscodingStreams.finalize(codec::ZstdCompression)
    safefree!(codec.cstream)
end

function safefree!(cstream::CStream)
    if cstream.ptr != C_NULL
        code = free!(cstream)
        if iserror(code)
            zstderror(cstream, code)
        end
        cstream.ptr = C_NULL
    end
    return
end

function TranscodingStreams.process(codec::ZstdCompression, input::Memory, output::Memory)
    cstream = codec.cstream
    cstream.ibuffer.src = input.ptr
    cstream.ibuffer.size = input.size
    cstream.ibuffer.pos = 0
    cstream.obuffer.dst = output.ptr
    cstream.obuffer.size = output.size
    cstream.obuffer.pos = 0
    if input.size == 0
        code = finish!(cstream)
    else
        code = compress!(cstream)
    end
    if iserror(code)
        error("zstd error")
    else
        Δin = Int(cstream.ibuffer.pos)
        Δout = Int(cstream.obuffer.pos)
        return Δin, Δout, input.size == 0 && code == 0 ? :end : :ok
    end
end
