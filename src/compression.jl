# Compression Codec
# =================

struct ZstdCompression <: TranscodingStreams.Codec
    cstream::CStream
    level::Int
end

function Base.show(io::IO, codec::ZstdCompression)
    print(io, summary(codec), "(level=$(codec.level))")
end

# Same as the zstd command line tool (v1.2.0).
const DEFAULT_COMPRESSION_LEVEL = 3

"""
    ZstdCompression(;level=$(DEFAULT_COMPRESSION_LEVEL))

Create a new zstd compression codec.

Arguments
---------
- `level`: compression level (1..$(MAX_CLEVEL))
"""
function ZstdCompression(;level::Integer=DEFAULT_COMPRESSION_LEVEL)
    if !(1 ≤ level ≤ MAX_CLEVEL)
        throw(ArgumentError("level must be within 1..$(MAX_CLEVEL)"))
    end
    return ZstdCompression(CStream(), level)
end

const ZstdCompressionStream{S} = TranscodingStream{ZstdCompression,S} where S<:IO

"""
    ZstdCompressionStream(stream::IO; kwargs...)

Create a new zstd compression stream (see `ZstdCompression` for `kwargs`).
"""
function ZstdCompressionStream(stream::IO; kwargs...)
    return TranscodingStream(ZstdCompression(;kwargs...), stream)
end


# Methods
# -------

function TranscodingStreams.initialize(codec::ZstdCompression)
    code = initialize!(codec.cstream, codec.level)
    if iserror(code)
        zstderror(codec.cstream, code)
    end
    return
end

function TranscodingStreams.finalize(codec::ZstdCompression)
    if codec.cstream.ptr != C_NULL
        code = free!(codec.cstream)
        if iserror(code)
            zstderror(codec.cstream, code)
        end
        codec.cstream.ptr = C_NULL
    end
    return
end

function TranscodingStreams.startproc(codec::ZstdCompression, mode::Symbol, error::Error)
    code = reset!(codec.cstream, 0 #=unknown source size=#)
    if iserror(code)
        error[] = ErrorException("zstd error")
        return :error
    end
    return :ok
end

function TranscodingStreams.process(codec::ZstdCompression, input::Memory, output::Memory, error::Error)
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
    Δin = Int(cstream.ibuffer.pos)
    Δout = Int(cstream.obuffer.pos)
    if iserror(code)
        error[] = ErrorException("zstd error")
        return Δin, Δout, :error
    else
        return Δin, Δout, input.size == 0 && code == 0 ? :end : :ok
    end
end
