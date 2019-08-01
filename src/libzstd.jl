# Low-level Interfaces
# ====================

function iserror(code::Csize_t)
    return ccall((:ZSTD_isError, libzstd), Cuint, (Csize_t,), code) != 0
end

function zstderror(stream, code::Csize_t)
    ptr = ccall((:ZSTD_getErrorName, libzstd), Cstring, (Csize_t,), code)
    error("zstd error: ", unsafe_string(ptr))
end

function max_clevel()
    return ccall((:ZSTD_maxCLevel, libzstd), Cint, ())
end

const MAX_CLEVEL = max_clevel()

# ZSTD_outBuffer
mutable struct InBuffer
    src::Ptr{Cvoid}
    size::Csize_t
    pos::Csize_t

    function InBuffer()
        return new(C_NULL, 0, 0)
    end
end

# ZSTD_inBuffer
mutable struct OutBuffer
    dst::Ptr{Cvoid}
    size::Csize_t
    pos::Csize_t

    function OutBuffer()
        return new(C_NULL, 0, 0)
    end
end

# ZSTD_CStream
mutable struct CStream
    ptr::Ptr{Cvoid}
    ibuffer::InBuffer
    obuffer::OutBuffer

    function CStream()
        ptr = ccall((:ZSTD_createCStream, libzstd), Ptr{Cvoid}, ())
        if ptr == C_NULL
            throw(OutOfMemoryError())
        end
        return new(ptr, InBuffer(), OutBuffer())
    end
end

function initialize!(cstream::CStream, level::Integer)
    return ccall((:ZSTD_initCStream, libzstd), Csize_t, (Ptr{Cvoid}, Cint), cstream.ptr, level)
end

function reset!(cstream::CStream, srcsize::Integer)
    return ccall((:ZSTD_resetCStream, libzstd), Csize_t, (Ptr{Cvoid}, Culonglong), cstream.ptr, srcsize)
end

function compress!(cstream::CStream)
    return ccall((:ZSTD_compressStream, libzstd), Csize_t, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), cstream.ptr, pointer_from_objref(cstream.obuffer), pointer_from_objref(cstream.ibuffer))
end

function finish!(cstream::CStream)
    return ccall((:ZSTD_endStream, libzstd), Csize_t, (Ptr{Cvoid}, Ptr{Cvoid}), cstream.ptr, pointer_from_objref(cstream.obuffer))
end

function free!(cstream::CStream)
    return ccall((:ZSTD_freeCStream, libzstd), Csize_t, (Ptr{Cvoid},), cstream.ptr)
end

# ZSTD_DStream
mutable struct DStream
    ptr::Ptr{Cvoid}
    ibuffer::InBuffer
    obuffer::OutBuffer

    function DStream()
        ptr = ccall((:ZSTD_createDStream, libzstd), Ptr{Cvoid}, ())
        if ptr == C_NULL
            throw(OutOfMemoryError())
        end
        return new(ptr, InBuffer(), OutBuffer())
    end
end

function initialize!(dstream::DStream)
    return ccall((:ZSTD_initDStream, libzstd), Csize_t, (Ptr{Cvoid},), dstream.ptr)
end

function reset!(dstream::DStream)
    return ccall((:ZSTD_resetDStream, libzstd), Csize_t, (Ptr{Cvoid},), dstream.ptr)
end

function decompress!(dstream::DStream)
    return ccall((:ZSTD_decompressStream, libzstd), Csize_t, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), dstream.ptr, pointer_from_objref(dstream.obuffer), pointer_from_objref(dstream.ibuffer))
end

function free!(dstream::DStream)
    return ccall((:ZSTD_freeDStream, libzstd), Csize_t, (Ptr{Cvoid},), dstream.ptr)
end


# Misc. functions
# ---------------

const ZSTD_CONTENTSIZE_UNKNOWN = Culonglong(0) - 1
const ZSTD_CONTENTSIZE_ERROR   = Culonglong(0) - 2

function find_decompressed_size(src::Ptr, size::Integer)
    return ccall((:ZSTD_findDecompressedSize, libzstd), Culonglong, (Ptr{Cvoid}, Csize_t), src, size)
end
