# Low-level Interfaces
# ====================

function iserror(code::Csize_t)
    return LibZstd.ZSTD_isError(code) != 0
end

function zstderror(stream, code::Csize_t)
    ptr = LibZstd.ZSTD_getErrorName(code)
    error("zstd error: ", unsafe_string(ptr))
end
function zstderror(code::Csize_t)
    ptr = LibZstd.ZSTD_getErrorName(code)
    error("zstd error: ", unsafe_string(ptr))
end
function checkerror(code::Csize_t)
    if iserror(code)
        zstderror(code)
    end
    code
end

function max_clevel()
    return LibZstd.ZSTD_maxCLevel()
end

const MAX_CLEVEL = max_clevel()

const InBuffer = LibZstd.ZSTD_inBuffer
InBuffer() = InBuffer(C_NULL, 0, 0)
Base.unsafe_convert(::Type{Ptr{InBuffer}}, buffer::InBuffer) = Ptr{InBuffer}(pointer_from_objref(buffer))
const OutBuffer = LibZstd.ZSTD_outBuffer
OutBuffer() = OutBuffer(C_NULL, 0, 0)
Base.unsafe_convert(::Type{Ptr{OutBuffer}}, buffer::OutBuffer) = Ptr{OutBuffer}(pointer_from_objref(buffer))

# ZSTD_CStream
mutable struct CStream
    ptr::Ptr{LibZstd.ZSTD_CStream}
    ibuffer::InBuffer
    obuffer::OutBuffer

    function CStream()
        ptr = LibZstd.ZSTD_createCStream()
        if ptr == C_NULL
            throw(OutOfMemoryError())
        end
        return new(ptr, InBuffer(), OutBuffer())
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
    return LibZstd.ZSTD_CCtx_setPledgedSrcSize(cstream, srcsize)
    #return ccall((:ZSTD_resetCStream, libzstd), Csize_t, (Ptr{Cvoid}, Culonglong), cstream.ptr, srcsize)

end

function compress!(cstream::CStream)
    return LibZstd.ZSTD_compressStream(cstream, cstream.obuffer, cstream.ibuffer)
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
        ptr = LibZstd.ZSTD_createDStream()
        if ptr == C_NULL
            throw(OutOfMemoryError())
        end
        return new(ptr, InBuffer(), OutBuffer())
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
    return LibZstd.ZSTD_DCtx_reset(dstream, LibZstd.ZSTD_reset_session_only)
end

function decompress!(dstream::DStream)
    return LibZstd.ZSTD_decompressStream(dstream, dstream.obuffer, dstream.ibuffer)
end

function free!(dstream::DStream)
    return LibZstd.ZSTD_freeDStream(dstream)
end

# Dictionary
# ==========

"""
    CodecZstd.Dictionary(buffer::AbstractVector{UInt8}, samplesBuffers::AbstractVector{UInt8}, sampleSizes::Vector{Csize_t})
    CodecZstd.Dictionary(samplesBuffers::AbstractVector{UInt8}, sampleSizes::Vector{Csize_t}, bufferCapacity=1024*100)
    CodecZstd.Dictionary(buffer::AbstractVector{UInt8}, samples::AbstractVector{UInt8}...)
    CodecZstd.Dictionary(bufferCapacity::Integer, samples::AbstractVector{UInt8}...)

Pre-trained dictionary used to aid ZSTD in the compression of small files.
`buffer` is pre-allocated UInt8 array used to contain the dictionary.
`samplesBuffers` is a single UInt8 array that constains the samples of size specified by `sampleSizes`
`bufferCapacity` specifies the byte size of the buffer to create.
`samples` is variable number of UInt8 arrays that will be used as samples. They will be concatenated together to form `samplesBuffers`.

Use with `loadDictionary(stream, dictionary)` to load the dictionary into a compression or decompression stream (CStream or DStream).
"""
mutable struct Dictionary{B <: AbstractVector{UInt8}}
    buffer::B
end
function Dictionary(buffer::AbstractVector{UInt8}, samplesBuffer::AbstractVector{UInt8}, samplesSizes::Vector{Csize_t})
    bufferSize = LibZstd.ZDICT_trainFromBuffer(buffer, sizeof(buffer), samplesBuffer, samplesSizes, length(samplesSizes))
    if LibZstd.ZDICT_isError(bufferSize) != 0
        throw(ErrorException("Error training Zstd dictionary. ZDICT: " * unsafe_string(LibZstd.ZDICT_getErrorName(bufferSize))))
    end
    Dictionary(@view buffer[1:Int(bufferSize)])
end
Dictionary(samplesBuffer::AbstractVector{UInt8}, samplesSizes::Vector{Csize_t}, bufferCapacity::Integer=1024*100) =
    Dictionary(Vector{UInt8}(undef, bufferCapacity), samplesBuffer, samplesSizes)
Dictionary(buffer::AbstractVector{UInt8}, samples::AbstractVector{UInt8}...) = Dictionary(buffer, vcat(samples...), Csize_t.(lengths.(samples)))
Dictionary(bufferCapacity::Integer, samples::AbstractVector{UInt8}...) = Dictionary(vcat(samples...), Csize_t.(lengths.(samples)), bufferCapacity)

"""
    CodecZstd.finalizeDictionary

    See documentation for ZDICT_finalizeDictionary
"""
function finalizeDictionary(
                dstDictBuffer::AbstractVector{UInt8}, dictContent::AbstractVector{UInt8},
                samplesBuffer::AbstractVector{UInt8}, samplesSizes::Vector{Csize_t},
                parameters::LibZstd.ZDICT_params_t
                )
    bufferSize = 
    LibZstd.ZDICT_finalizeDictionary(dstDictBuffer, size(dstDictBuffer),
                                     dictContent,   size(dictContent),
                                     samplesBuffer,
                                     samplesSizes, length(samplesSizes),
                                     parameters
    )
    if LibZstd.ZDICT_isError(bufferSize) != 0
        throw(ErrorException("Error training Zstd dictionary. ZDICT: " * unsafe_string(LibZstd.ZDICT_getErrorName(bufferSize))))
    end
    Dictionary(@view dstDictBuffer[1:Int(bufferSize)])
end

Base.size(dict::Dictionary) = Int.(size(dict.buffer))
Base.length(dict::Dictionary) = Int(length(dict.buffer))
Base.pointer(dict::Dictionary) = pointer(dict.buffer)
Base.unsafe_convert(::Type{Ptr{Nothing}}, dict::Dictionary) = pointer(dict)
getHeaderSize(dict::Dictionary) = Int(LibZstd.ZDICT_getDictHeaderSize(dict, length(dict)))
getID(dict::Dictionary) = LibZstd.ZDICT_getDictID(dict, length(dict))

# CDict

# This actually just a box for an opaque pointer
mutable struct CDict
    ptr::Ptr{LibZstd.ZSTD_CDict}
    function CDict(ptr)
        cdict = new(ptr)
        finalizer(free!, cdict)
    end
end
createCDict(dict::Dictionary, compressionLevel) =
    LibZstd.ZSTD_createCDict(dict.buffer, length(dict), compressionLevel)
free!(ptr::Ptr{CDict}) = LibZstd.ZSTD_freeCDict(ptr)
free!(cdict::CDict) = free!(cdict.ptr)
Base.unsafe_convert(::Type{Ptr{LibZstd.ZSTD_CDict}}, cdict::CDict) = cdict.ptr

function loadDictionary(cstream::CStream, dict::Dictionary)
    checkerror( LibZstd.ZSTD_CCtx_loadDictionary(cstream, dict, length(dict)) )
end
function loadDictionary(cstream::CStream, cdict::CDict)
    checkerror( LibZstd.ZSTD_CCtx_refCDict(cstream, cdict) )
end

# DDict

# This actually just a box for an opaque pointer
mutable struct DDict
    ptr::Ptr{LibZstd.ZSTD_DDict}
    function DDict(ptr)
        ddict = new(ptr)
        finalizer(free!, ddict)
    end
end
createDDict(dict::Dictionary) = 
    LibZstd.ZSTD_createDDict(dict.buffer, length(dict))
free!(ptr::Ptr{DDict}) = LibZstd.ZSTD_freeDDict(ptr)
free!(ddict::DDict) = free!(ddict.ptr)
Base.unsafe_convert(::Type{Ptr{LibZstd.ZSTD_DDict}}, cdict::DDict) = cdict.ptr

function loadDictionary(dstream::DStream, dict::Dictionary)
    checkerror( LibZstd.ZSTD_DCtx_loadDictionary(dstream, dict, length(dict)) )
end
function loadDirectory(dstream::DStream, ddict::DDict)
    checkerror( LibZstd.ZSTD_DCtx_refDDict(dstream, ddict) )
end

# Parameters
# ==========

function setParameter(cstream::CStream, parameter::LibZstd.ZSTD_cParameter, value)
    checkerror( LibZstd.ZSTD_CCtx_setParameter(cstream, parameter, value) )
end
function getParameter(cstream::CStream, parameter::LibZstd.ZSTD_cParameter, out=Ref{Cint}())
    checkerror( LibZstd.ZSTD_CCtx_getParameter(cstream, parameter, out) )
    out[]
end

"""
    CStreamParameters

An AbstractDict interface to that allows retrieving and setting the parameters for a 
compression stream
"""
struct CStreamParameters <: AbstractDict{LibZstd.ZSTD_cParameter, Cint}
    cstream::CStream
end
Base.keys(params::CStreamParameters) = instances(LibZstd.ZSTD_cParameter)
Base.values(params::CStreamParameters) = (getParameter(params.cstream, param) for param in keys(params))
Base.getindex(params::CStreamParameters, key::LibZstd.ZSTD_cParameter) = getParameter(params.cstream, key)
Base.setindex!(params::CStreamParameters, value, key::LibZstd.ZSTD_cParameter) = setParameter(params.cstream, key, value)
function Base.iterate(params::CStreamParameters, state=1)
    ks = keys(params)
    if state <= length(ks)
        k = ks[state]
        return (k => params[k], state+1)
    else
        return nothing
    end
end
Base.length(::CStreamParameters) = length(instances(LibZstd.ZSTD_cParameter))

function getParameters(cstream::CStream)
    CStreamParameters(cstream)
end
function setParameter(dstream::DStream, parameter::LibZstd.ZSTD_dParameter, value)
    checkerror( LibZstd.ZSTD_DCtx_setParameter(dstream, parameter, value) )
end
function getParameter(dstream::DStream, parameter::LibZstd.ZSTD_dParameter, out=Ref{Cint}())
    checkerror( LibZstd.ZSTD_DCtx_getParameter(dstream, parameter, out) )
    out[]
end

"""
    DStreamParameters

An AbstractDict that allows retrieving and setting the parameters for a 
decompression stream
"""
struct DStreamParameters <: AbstractDict{LibZstd.ZSTD_dParameter, Cint}
    dstream::DStream
end
Base.keys(params::DStreamParameters) = instances(LibZstd.ZSTD_dParameter)
Base.values(params::DStreamParameters) = (getParameter(params.dstream, param) for param in keys(params))
Base.getindex(params::DStreamParameters, key::LibZstd.ZSTD_dParameter) = getParameter(params.dstream, key)
Base.setindex!(params::DStreamParameters, value, key::LibZstd.ZSTD_dParameter) = setParameter(params.dstream, value, key)
function Base.iterate(params::DStreamParameters, state=1)
    ks = keys(params)
    if state <= length(ks)
        k = ks[state]
        return (k => params[k], state+1)
    else
        return nothing
    end
end
Base.length(::DStreamParameters) = length(instances(LibZstd.ZSTD_dParameter))

function getParameters(dstream::DStream)
    DStreamParameters(dstream)
end


# Misc. functions
# ---------------

const ZSTD_CONTENTSIZE_UNKNOWN = Culonglong(0) - 1
const ZSTD_CONTENTSIZE_ERROR   = Culonglong(0) - 2

function find_decompressed_size(src::Ptr, size::Integer)
    return LibZstd.ZSTD_findDecompressedSize(src, size)
end
