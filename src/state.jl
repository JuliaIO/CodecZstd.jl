# State
# =====

mutable struct State
    data::Vector{UInt8}
    bufferpos::Int
    marginpos::Int

    function State(bufsize::Integer)
        @assert bufsize > 0
        return new(Vector{UInt8}(bufsize), 1, 1)
    end
end

function bufferptr(state)
    return pointer(state.data, state.bufferpos)
end

function buffersize(state)
    return state.marginpos - state.bufferpos
end

function marginptr(state)
    return pointer(state.data, state.marginpos)
end

function marginsize(state)
    return endof(state.data) - state.marginpos + 1
end

function fillbuffer!(source, state)
    if state.bufferpos == state.marginpos
        state.bufferpos = state.marginpos = 1
    end
    n = TranscodingStreams.unsafe_read(source, marginptr(state), marginsize(state))
    state.marginpos += n
    return n
end

function flushbuffer!(sink, state)
    n = unsafe_write(sink, bufferptr(state), buffersize(state))
    state.bufferpos += n
    if state.bufferpos == state.marginpos
        state.bufferpos = state.marginpos = 1
    end
    return n
end
