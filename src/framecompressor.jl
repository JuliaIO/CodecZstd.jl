# ZstdFrameCompressor Codec.
# ==================


struct ZstdFrameCompressor <: TranscodingStreams.Codec
    cstream::CStream
    in_buffer::Vector{UInt8}
    outputting::Base.RefValue{Bool}
    dead::Base.RefValue{Bool}
    level::Cint
end

function Base.show(io::IO, codec::ZstdFrameCompressor)
    print(io, summary(codec), "(level=$(codec.level))")
end

"""
ZstdFrameCompressor(;level=$(DEFAULT_COMPRESSION_LEVEL))

Create a new zstd compression codec.

This will buffer all input in a frame to ensure the decompressed size is stored
in the frame header. This will use more memory than `ZstdCompressor`,
but may be faster to decode.

Arguments
---------
- `level`: compression level (1..$(MAX_CLEVEL))
"""
function ZstdFrameCompressor(;level::Integer=DEFAULT_COMPRESSION_LEVEL)
    if !(1 ≤ level ≤ MAX_CLEVEL)
        throw(ArgumentError("level must be within 1..$(MAX_CLEVEL)"))
    end
    ZstdFrameCompressor(CStream(), UInt8[], Ref(false), Ref(false), level)
end

# Methods
# -------

function TranscodingStreams.initialize(codec::ZstdFrameCompressor)
    code = initialize!(codec.cstream, codec.level)
    if iserror(code)
        zstderror(codec.cstream, code)
    end
    return
end

function TranscodingStreams.finalize(codec::ZstdFrameCompressor)
    if codec.cstream.ptr != C_NULL
        code = free!(codec.cstream)
        if iserror(code)
            zstderror(codec.cstream, code)
        end
        codec.cstream.ptr = C_NULL
    end
    return
end

function TranscodingStreams.startproc(codec::ZstdFrameCompressor, mode::Symbol, error::Error)
    empty!(codec.in_buffer)
    codec.outputting[] = false
    codec.dead[] = false
    code = reset!(codec.cstream, 0 #=unknown source size=#)
    if iserror(code)
        error[] = ErrorException("zstd error")
        return :error
    end
    return :ok
end

function TranscodingStreams.process(codec::ZstdFrameCompressor, input::Memory, output::Memory, error::Error)::Tuple{Int,Int,Symbol}
    if codec.dead[]
        error[] = ErrorException("codec dead, call `startproc` to reset.")
        return 0, 0, :error
    end
    in_buffer = codec.in_buffer
    nb = length(in_buffer)
    if input.size > typemax(Int) - 1 - nb
        codec.dead[] = true
        error[] = ErrorException("`ZstdFrameCompressor` can compress at most $(typemax(Int)-1) bytes. Got $(Int128(input.size) + Int128(nb)) bytes.")
        return 0, 0, :error
    end
    if iszero(input.size)
        # write the output
        cstream = codec.cstream
        if !codec.outputting[]
            codec.outputting[] = true
            cstream.ibuffer.pos = 0
        end
        cstream.ibuffer.src = pointer(in_buffer)
        cstream.ibuffer.size = nb
        cstream.obuffer.dst = output.ptr
        cstream.obuffer.size = output.size
        cstream.obuffer.pos = 0
        code = compress!(cstream; endOp = LibZstd.ZSTD_e_end)
        Δout = Int(cstream.obuffer.pos)
        if iserror(code)
            codec.dead[] = true
            error[] = ErrorException("zstd error")
            return 0, Δout, :error
        elseif iszero(code)
            codec.dead[] = true
            return 0, Δout, :end
        else
            # output.size too small.
            # This should normally not happen because of minoutsize
            return 0, Δout, :ok
        end
    else
        # Append input to in_buffer
        if codec.outputting[]
            error[] = ErrorException("codec is still outputting a frame.")
            return 0, 0, :error
        end
        try
            resize!(in_buffer, nb + input.size)
            GC.@preserve in_buffer unsafe_copyto!(pointer(in_buffer, nb+1), input.ptr, input.size)
        catch e
            # resize! may fail, but if it does, the error must be caught to allow
            # TranscodingStreams.finalize to be called.
            codec.dead[] = true
            error[] = e
            return 0, 0, :error
        end
        return Int(input.size), 0, :ok
    end
end

function TranscodingStreams.minoutsize(codec::ZstdFrameCompressor, input::Memory)::Int
    if iszero(input.size)
        LibZstd.ZSTD_compressBound(length(codec.in_buffer))
    else
        0
    end
end

function TranscodingStreams.expectedsize(codec::ZstdFrameCompressor, input::Memory)::Int
    LibZstd.ZSTD_compressBound(input.size)
end
