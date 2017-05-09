# Deflation
# =========

struct ZstdDeflation <: Codec
    cstream::CStream
    state::State
end

# Same as the zstd command line tool (v1.2.0).
const DEFAULT_COMPRESSION_LEVEL = 3

function ZstdDeflation(;level=DEFAULT_COMPRESSION_LEVEL)
    cstream = CStream()
    initialize!(cstream, level)
    state = State(1024)
    # TODO: This should be implemented in TranscodingStreams.jl.
    finalizer(state, _->free!(cstream))
    return ZstdDeflation(cstream, state)
end

function ZstdDeflationStream(stream::IO)
    return TranscodingStream(ZstdDeflation, stream)
end

function process(::Type{Read}, codec::ZstdDeflation, source::IO, output::Ptr{UInt8}, nbytes::Int)::Tuple{Int,ProcCode}
    # set up
    state = codec.state
    fillbuffer!(source, state)
    cstream = codec.cstream
    cstream.ibuffer.src = bufferptr(state)
    cstream.ibuffer.size = buffersize(state)
    cstream.obuffer.dst = output
    cstream.obuffer.size = nbytes

    # deflate data
    if buffersize(state) == 0 && eof(source)
        code = finish!(cstream)
        if iserror(code)
            error("zstd error")
        end
        return Int(cstream.obuffer.pos), code == 0 ? PROC_FINISH : PROC_OK
    else
        code = compress!(cstream)
        state.bufferpos += cstream.ibuffer.pos
        if iserror(code)
            error("zstd error")
        end
        return Int(cstream.obuffer.pos), PROC_OK
    end
end

function process(::Type{Write}, codec::ZstdDeflation, sink::IO, input::Ptr{UInt8}, nbytes::Int)::Tuple{Int,ProcCode}
    # set up
    state = codec.state
    flushbuffer!(sink, state)
    cstream = codec.cstream
    cstream.ibuffer.src = input
    cstream.ibuffer.size = nbytes
    cstream.obuffer.dst = marginptr(state)
    cstream.obuffer.size = marginsize(state)

    # deflate data
    code = compress!(cstream)
    state.marginpos += cstream.obuffer.pos
    if iserror(code)
        error("zstd error")
    else
        return Int(cstream.ibuffer.pos), PROC_OK
    end
end

function finish(::Type{Write}, codec::ZstdDeflation, sink::IO)
    state = codec.state
    cstream = codec.cstream
    while true
        flushbuffer!(sink, state)
        cstream.obuffer.dst = marginptr(state)
        cstream.obuffer.size = marginsize(state)
        code = finish!(cstream)
        state.marginpos += cstream.obuffer.pos
        if code == 0
            break
        elseif iserror(code)
            error("zstd error")
        else
            # continue
        end
    end
    while buffersize(state) > 0
        flushbuffer!(sink, state)
    end
end
