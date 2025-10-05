# Decompressor Codec
# ==================

"""
    windowLogMax_bounds() -> min::Int32, max::Int32

Return the minimum and maximum windowLogMax available.
"""
function windowLogMax_bounds()
    bounds = LibZstd.ZSTD_dParam_getBounds(LibZstd.ZSTD_d_windowLogMax)
    @assert !iserror(bounds.error)
    Int32(bounds.lowerBound), Int32(bounds.upperBound)
end

struct ZstdDecompressor <: TranscodingStreams.Codec
    dstream::DStream
    windowLogMax::Int32
end

function Base.show(io::IO, codec::ZstdDecompressor)
    print(io, summary(codec), "(")
    if codec.windowLogMax != Int32(0)
        print(io, "windowLogMax=Int32($(codec.windowLogMax))")
    end
    print(io, ")")
end

"""
    ZstdDecompressor()

Create a new zstd decompression codec.

Arguments
---------

Advanced decompression parameters.

- `windowLogMax::Int32= Int32(0)`: Select a size limit (in power of 2) beyond which
  the streaming API will refuse to allocate memory buffer
  in order to protect the host from unreasonable memory requirements.
  This parameter is only useful in streaming mode, since no internal buffer is allocated in single-pass mode.
  By default, a decompression context accepts window sizes <= (1 << ZSTD_WINDOWLOG_LIMIT_DEFAULT).
  Must be clamped between `windowLogMax_bounds()[1]` and `windowLogMax_bounds()[2]` inclusive.
  Special: value 0 means "use default maximum windowLog".
"""
function ZstdDecompressor(;
        windowLogMax::Int32=Int32(0),
    )
    windowLogMax_range = range(windowLogMax_bounds()...)
    if !iszero(windowLogMax) && windowLogMax ∉ windowLogMax_range
        throw(ArgumentError("windowLogMax ∈ $(windowLogMax_range) must hold. Got\nwindowLogMax => $(windowLogMax)"))
    end
    return ZstdDecompressor(DStream(), windowLogMax)
end

const ZstdDecompressorStream{S} = TranscodingStream{ZstdDecompressor,S} where S<:IO

"""
    ZstdDecompressorStream(stream::IO; kwargs...)

Create a new zstd decompression stream (`kwargs` are passed to `TranscodingStream`).
"""
function ZstdDecompressorStream(stream::IO; kwargs...)
    x, y = splitkwargs(kwargs, (:windowLogMax,))
    return TranscodingStream(ZstdDecompressor(;x...), stream; y...)
end


# Methods
# -------

function TranscodingStreams.finalize(codec::ZstdDecompressor)
    if codec.dstream.ptr != C_NULL
        # This should never fail
        ret = free!(codec.dstream)
        @assert !iserror(ret)
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
        if !iszero(codec.windowLogMax)
            ret = LibZstd.ZSTD_DCtx_setParameter(codec.dstream, LibZstd.ZSTD_d_windowLogMax, Cint(codec.windowLogMax))
            if iserror(ret)
                # This should be unreachable because windowLogMax is checked in the constructor.
                err[] = ErrorException("zstd error setting windowLogMax")
                return :error
            end
        end
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
        err[] = if error_code(code) == Integer(LibZstd.ZSTD_error_frameParameter_windowTooLarge)
            ErrorException("zstd decompression error: Window size larger than maximum.\nHint: try increasing `windowLogMax` when constructing the `ZstdDecompressor`")
            # TODO It is possible to find the requested window size by parsing the frame header.
            # This could be used to get a better error message.
        else
            ErrorException("zstd decompression error: " * error_name(code))
        end
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
