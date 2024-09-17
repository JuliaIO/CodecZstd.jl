# Low-level Interfaces
# ====================

function iserror(code::Csize_t)
    return LibZstd.ZSTD_isError(code) != 0
end

function zstderror(stream, code::Csize_t)
    ptr = LibZstd.ZSTD_getErrorName(code)
    error("zstd error: ", unsafe_string(ptr))
end

function max_clevel()
    return LibZstd.ZSTD_maxCLevel()
end

const MAX_CLEVEL = max_clevel()

# InBuffer is the C struct ZSTD_inBuffer
const InBuffer = LibZstd.ZSTD_inBuffer
InBuffer() = InBuffer(C_NULL, 0, 0)
Base.unsafe_convert(::Type{Ptr{InBuffer}}, buffer::InBuffer) = Ptr{InBuffer}(pointer_from_objref(buffer))
function reset!(buf::InBuffer)
    buf.src = C_NULL
    buf.pos = 0
    buf.size = 0
end

# OutBuffer is the C struct ZSTD_outBuffer
const OutBuffer = LibZstd.ZSTD_outBuffer
OutBuffer() = OutBuffer(C_NULL, 0, 0)
Base.unsafe_convert(::Type{Ptr{OutBuffer}}, buffer::OutBuffer) = Ptr{OutBuffer}(pointer_from_objref(buffer))
function reset!(buf::OutBuffer)
    buf.dst = C_NULL
    buf.pos = 0
    buf.size = 0
end


# ZSTD_CStream
mutable struct CStream
    ptr::Ptr{LibZstd.ZSTD_CStream}
    ibuffer::InBuffer
    obuffer::OutBuffer

    function CStream()
        return new(C_NULL, InBuffer(), OutBuffer())
    end
end

Base.unsafe_convert(::Type{Ptr{LibZstd.ZSTD_CStream}}, cstream::CStream) = cstream.ptr
Base.unsafe_convert(::Type{Ptr{InBuffer}}, cstream::CStream) = Base.unsafe_convert(Ptr{InBuffer}, cstream.ibuffer)
Base.unsafe_convert(::Type{Ptr{OutBuffer}}, cstream::CStream) = Base.unsafe_convert(Ptr{OutBuffer}, cstream.obuffer)

function initialize!(cstream::CStream, level::Integer)
    return LibZstd.ZSTD_initCStream(cstream, level)
end

function reset!(cstream::CStream, srcsize::Integer)
    # ZSTD_resetCStream is deprecated
    # https://github.com/facebook/zstd/blob/9d2a45a705e22ad4817b41442949cd0f78597154/lib/zstd.h#L2253-L2272
    res = LibZstd.ZSTD_CCtx_reset(cstream, LibZstd.ZSTD_reset_session_only)
    if iserror(res)
        return res
    end
    if srcsize == 0
        # From zstd.h:
        # Note: ZSTD_resetCStream() interprets pledgedSrcSize == 0 as ZSTD_CONTENTSIZE_UNKNOWN, but
        # ZSTD_CCtx_setPledgedSrcSize() does not do the same, so ZSTD_CONTENTSIZE_UNKNOWN must be
        # explicitly specified.
        srcsize = ZSTD_CONTENTSIZE_UNKNOWN
    end
    reset!(cstream.ibuffer)
    reset!(cstream.obuffer)
    return LibZstd.ZSTD_CCtx_setPledgedSrcSize(cstream, srcsize)
end

"""
    compress!(cstream::CStream; endOp=:continue)

Compress a Zstandard `CStream`. Optionally, provide one one of the following end directives
* `:continue` - (default) collect more data, encoder decides when to output compressed result, for optimal compression ratio
* `:flush` - flush any data provided so far
* `:end` - flush any remaining data _and_ close current frame

If `:end` is provided on the first call to `compress!`, the size of the input data will be recorded in the frame header.
This is equivalent to calling [`CodecZstd.LibZstd.ZSTD_compress2`](@ref).
See also [`CodecZstd.LibZstd.ZSTD_CCtx_setPledgedSrcSize`](@ref).

See the Zstd manual for additional details:
https://facebook.github.io/zstd/zstd_manual.html
"""
function compress!(cstream::CStream; endOp::Union{Symbol,LibZstd.ZSTD_EndDirective}=LibZstd.ZSTD_e_continue)
    return LibZstd.ZSTD_compressStream2(cstream, cstream.obuffer, cstream.ibuffer, endOp)
end

# Support endOp keyword of compress! above when providing a Symbol
function Base.convert(::Type{LibZstd.ZSTD_EndDirective}, endOp::Symbol)
    endOp = if endOp == :continue
        LibZstd.ZSTD_e_continue
    elseif endOp == :flush
        LibZstd.ZSTD_e_flush
    elseif endOp == :end
        LibZstd.ZSTD_e_end
    else
        throw(ArgumentError("Received value `:$endOp` for `endOp`, but only :continue, :flush, or :end are allowed values."))
    end
    return endOp
end

function finish!(cstream::CStream)
    return LibZstd.ZSTD_endStream(cstream, cstream.obuffer)
end

function free!(cstream::CStream)
    return LibZstd.ZSTD_freeCStream(cstream)
end

# ZSTD_DStream
mutable struct DStream
    ptr::Ptr{LibZstd.ZSTD_DStream}
    ibuffer::InBuffer
    obuffer::OutBuffer

    function DStream()
        return new(C_NULL, InBuffer(), OutBuffer())
    end
end
Base.unsafe_convert(::Type{Ptr{LibZstd.ZSTD_DStream}}, dstream::DStream) = dstream.ptr
Base.unsafe_convert(::Type{Ptr{InBuffer}}, dstream::DStream) = Ptr{InBuffer}(Base.unsafe_convert(Ptr{InBuffer}, dstream.ibuffer))
Base.unsafe_convert(::Type{Ptr{OutBuffer}}, dstream::DStream) = Ptr{OutBuffer}(Base.unsafe_convert(Ptr{OutBuffer}, dstream.obuffer))

function initialize!(dstream::DStream)
    return LibZstd.ZSTD_initDStream(dstream)
end

function reset!(dstream::DStream)
    # LibZstd.ZSTD_resetDStream is deprecated
    # https://github.com/facebook/zstd/blob/9d2a45a705e22ad4817b41442949cd0f78597154/lib/zstd.h#L2332-L2339
    reset!(dstream.ibuffer)
    reset!(dstream.obuffer)
    return LibZstd.ZSTD_DCtx_reset(dstream, LibZstd.ZSTD_reset_session_only)
end

function decompress!(dstream::DStream)
    return LibZstd.ZSTD_decompressStream(dstream, dstream.obuffer, dstream.ibuffer)
end

function free!(dstream::DStream)
    return LibZstd.ZSTD_freeDStream(dstream)
end


# Misc. functions
# ---------------

const ZSTD_CONTENTSIZE_UNKNOWN = Culonglong(0) - 1
const ZSTD_CONTENTSIZE_ERROR   = Culonglong(0) - 2

"""
    find_decompressed_size(src::Vector{UInt8})
    find_decompressed_size(src::Ptr, srcSize::Integer)

Find the decompressed size of a source buffer containing one or more frames.

This function should act identically to `ZSTD_findFrameDecompressedSize` which
is part of the static only API.

Normally, this function should return the size in terms of bytes of all the frames
decompressed.

May return `ZSTD_CONTENTSIZE_UNKNOWN` or `ZSTD_CONTENTSIZE_ERROR`:
1. Return a code above if `ZSTD_getFrameContentSize` returns the code.
2. Return `ZSTD_CONTENTSIZE_ERROR` if `ZSTD_findFrameCompressedSize` errors.
3. Return `ZSTD_CONTENTSIZE_ERROR` if the frame extends beyond `srcSize`
"""
function find_decompressed_size(src::Vector{UInt8})
    GC.@preserve src find_decompressed_size(pointer(src), length(src))
end
function find_decompressed_size(src::Ptr, srcSize::Integer)
    frameOffset = Csize_t(0)
    decompressedSize = Culonglong(0)

    while frameOffset < srcSize
        frameSrc = src + frameOffset
        remainingSize = srcSize - frameOffset

        # Obtain the decompressed frame content size of the next frame, accumulate
        frameContentSize = LibZstd.ZSTD_getFrameContentSize(frameSrc, remainingSize)
        if frameContentSize == ZSTD_CONTENTSIZE_UNKNOWN
            return ZSTD_CONTENTSIZE_UNKNOWN
        end
        if frameContentSize == ZSTD_CONTENTSIZE_ERROR
            return ZSTD_CONTENTSIZE_ERROR
        end
        decompressedSize, overflow = Base.add_with_overflow(decompressedSize, frameContentSize)
        if overflow
            return ZSTD_CONTENTSIZE_ERROR
        end

        # Advance the offset forward by the size of the compressed frame
        frameCompressedSize = LibZstd.ZSTD_findFrameCompressedSize(frameSrc, remainingSize)
        if iserror(frameCompressedSize) || frameCompressedSize <= 0
            return ZSTD_CONTENTSIZE_ERROR
        end
        frameOffset += frameCompressedSize
    end

    # frameOffset > srcSize
    if frameOffset != srcSize
        return ZSTD_CONTENTSIZE_ERROR
    end

    return decompressedSize
end
