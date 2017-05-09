# Inflation
# =========

struct ZstdInflation <: Codec
    dstream::DStream
    state::State
end

function ZstdInflation()
    dstream = DStream()
    initialize!(dstream)
    state = State(1024)
    # TODO: This should be implemented in TranscodingStreams.jl.
    finalizer(state, _->free!(dstream))
    return ZstdInflation(dstream, state)
end

function ZstdInflationStream(stream::IO)
    return TranscodingStream(ZstdInflation, stream)
end

function process(::Type{Read}, codec::ZstdInflation, source::IO, output::Ptr{UInt8}, nbytes::Int)::Tuple{Int,ProcCode}
    # set up
    state = codec.state
    fillbuffer!(source, state)
    dstream = codec.dstream
    dstream.ibuffer.src = bufferptr(state)
    dstream.ibuffer.size = buffersize(state)
    dstream.ibuffer.pos = 0
    dstream.obuffer.dst = output
    dstream.obuffer.size = nbytes
    dstream.obuffer.pos = 0

    # inflate data
    code = decompress!(dstream)
    state.bufferpos += dstream.ibuffer.pos
    if iserror(code)
        error("zstd error")
    else
        return Int(dstream.obuffer.pos), code == 0 ? PROC_FINISH : PROC_OK
    end
end

function process(::Type{Write}, codec::ZstdInflation, sink::IO, input::Ptr{UInt8}, nbytes::Int)::Tuple{Int,ProcCode}
    # set up
    state = codec.state
    flushbuffer!(sink, state)
    dstream = codec.dstream
    dstream.ibuffer.src = input
    dstream.ibuffer.pos = 0
    dstream.ibuffer.size = nbytes
    dstream.obuffer.dst = marginptr(state)
    dstream.obuffer.pos = 0
    dstream.obuffer.size = marginsize(state)

    # inflate data
    code = decompress!(dstream)
    state.marginpos += dstream.obuffer.pos
    if iserror(code)
        error("zstd error")
    else
        return Int(dstream.ibuffer.pos), code == 0 ? PROC_FINISH : PROC_OK
    end
end

function finish(::Type{Write}, codec::ZstdInflation, sink::IO)
    state = codec.state
    while buffersize(state) > 0
        flushbuffer!(sink, state)
    end
end
