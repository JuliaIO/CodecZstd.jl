module LibZstd

using Zstd_jll
export Zstd_jll

const INT_MAX = typemax(Cint)
const size_t = Int64

ZSTD_EXPAND_AND_QUOTE(expr) = string(expr)


function ZDICT_trainFromBuffer(dictBuffer, dictBufferCapacity, samplesBuffer, samplesSizes, nbSamples)
    ccall((:ZDICT_trainFromBuffer, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Ptr{Csize_t}, Cuint), dictBuffer, dictBufferCapacity, samplesBuffer, samplesSizes, nbSamples)
end

struct ZDICT_params_t
    compressionLevel::Cint
    notificationLevel::Cuint
    dictID::Cuint
end

function ZDICT_finalizeDictionary(dstDictBuffer, maxDictSize, dictContent, dictContentSize, samplesBuffer, samplesSizes, nbSamples, parameters)
    ccall((:ZDICT_finalizeDictionary, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Ptr{Csize_t}, Cuint, ZDICT_params_t), dstDictBuffer, maxDictSize, dictContent, dictContentSize, samplesBuffer, samplesSizes, nbSamples, parameters)
end

function ZDICT_getDictID(dictBuffer, dictSize)
    ccall((:ZDICT_getDictID, libzstd), Cuint, (Ptr{Cvoid}, Csize_t), dictBuffer, dictSize)
end

function ZDICT_getDictHeaderSize(dictBuffer, dictSize)
    ccall((:ZDICT_getDictHeaderSize, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t), dictBuffer, dictSize)
end

function ZDICT_isError(errorCode)
    ccall((:ZDICT_isError, libzstd), Cuint, (Csize_t,), errorCode)
end

function ZDICT_getErrorName(errorCode)
    ccall((:ZDICT_getErrorName, libzstd), Ptr{Cchar}, (Csize_t,), errorCode)
end

function ZSTD_versionNumber()
    ccall((:ZSTD_versionNumber, libzstd), Cuint, ())
end

function ZSTD_versionString()
    ccall((:ZSTD_versionString, libzstd), Ptr{Cchar}, ())
end

function ZSTD_compress(dst, dstCapacity, src, srcSize, compressionLevel)
    ccall((:ZSTD_compress, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Cint), dst, dstCapacity, src, srcSize, compressionLevel)
end

function ZSTD_decompress(dst, dstCapacity, src, compressedSize)
    ccall((:ZSTD_decompress, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t), dst, dstCapacity, src, compressedSize)
end

function ZSTD_getFrameContentSize(src, srcSize)
    ccall((:ZSTD_getFrameContentSize, libzstd), Culonglong, (Ptr{Cvoid}, Csize_t), src, srcSize)
end

function ZSTD_getDecompressedSize(src, srcSize)
    ccall((:ZSTD_getDecompressedSize, libzstd), Culonglong, (Ptr{Cvoid}, Csize_t), src, srcSize)
end

function ZSTD_findFrameCompressedSize(src, srcSize)
    ccall((:ZSTD_findFrameCompressedSize, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t), src, srcSize)
end

function ZSTD_compressBound(srcSize)
    ccall((:ZSTD_compressBound, libzstd), Csize_t, (Csize_t,), srcSize)
end

function ZSTD_isError(code)
    ccall((:ZSTD_isError, libzstd), Cuint, (Csize_t,), code)
end

function ZSTD_getErrorName(code)
    ccall((:ZSTD_getErrorName, libzstd), Ptr{Cchar}, (Csize_t,), code)
end

function ZSTD_minCLevel()
    ccall((:ZSTD_minCLevel, libzstd), Cint, ())
end

function ZSTD_maxCLevel()
    ccall((:ZSTD_maxCLevel, libzstd), Cint, ())
end

function ZSTD_defaultCLevel()
    ccall((:ZSTD_defaultCLevel, libzstd), Cint, ())
end

mutable struct ZSTD_CCtx_s end

const ZSTD_CCtx = ZSTD_CCtx_s

function ZSTD_createCCtx()
    ccall((:ZSTD_createCCtx, libzstd), Ptr{ZSTD_CCtx}, ())
end

function ZSTD_freeCCtx(cctx)
    ccall((:ZSTD_freeCCtx, libzstd), Csize_t, (Ptr{ZSTD_CCtx},), cctx)
end

function ZSTD_compressCCtx(cctx, dst, dstCapacity, src, srcSize, compressionLevel)
    ccall((:ZSTD_compressCCtx, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Cint), cctx, dst, dstCapacity, src, srcSize, compressionLevel)
end

mutable struct ZSTD_DCtx_s end

const ZSTD_DCtx = ZSTD_DCtx_s

function ZSTD_createDCtx()
    ccall((:ZSTD_createDCtx, libzstd), Ptr{ZSTD_DCtx}, ())
end

function ZSTD_freeDCtx(dctx)
    ccall((:ZSTD_freeDCtx, libzstd), Csize_t, (Ptr{ZSTD_DCtx},), dctx)
end

function ZSTD_decompressDCtx(dctx, dst, dstCapacity, src, srcSize)
    ccall((:ZSTD_decompressDCtx, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t), dctx, dst, dstCapacity, src, srcSize)
end

@enum ZSTD_strategy::UInt32 begin
    ZSTD_fast = 1
    ZSTD_dfast = 2
    ZSTD_greedy = 3
    ZSTD_lazy = 4
    ZSTD_lazy2 = 5
    ZSTD_btlazy2 = 6
    ZSTD_btopt = 7
    ZSTD_btultra = 8
    ZSTD_btultra2 = 9
end

@enum ZSTD_cParameter::UInt32 begin
    ZSTD_c_compressionLevel = 100
    ZSTD_c_windowLog = 101
    ZSTD_c_hashLog = 102
    ZSTD_c_chainLog = 103
    ZSTD_c_searchLog = 104
    ZSTD_c_minMatch = 105
    ZSTD_c_targetLength = 106
    ZSTD_c_strategy = 107
    ZSTD_c_targetCBlockSize = 130
    ZSTD_c_enableLongDistanceMatching = 160
    ZSTD_c_ldmHashLog = 161
    ZSTD_c_ldmMinMatch = 162
    ZSTD_c_ldmBucketSizeLog = 163
    ZSTD_c_ldmHashRateLog = 164
    ZSTD_c_contentSizeFlag = 200
    ZSTD_c_checksumFlag = 201
    ZSTD_c_dictIDFlag = 202
    ZSTD_c_nbWorkers = 400
    ZSTD_c_jobSize = 401
    ZSTD_c_overlapLog = 402
    ZSTD_c_experimentalParam1 = 500
    ZSTD_c_experimentalParam2 = 10
    ZSTD_c_experimentalParam3 = 1000
    ZSTD_c_experimentalParam4 = 1001
    ZSTD_c_experimentalParam5 = 1002
    ZSTD_c_experimentalParam7 = 1004
    ZSTD_c_experimentalParam8 = 1005
    ZSTD_c_experimentalParam9 = 1006
    ZSTD_c_experimentalParam10 = 1007
    ZSTD_c_experimentalParam11 = 1008
    ZSTD_c_experimentalParam12 = 1009
    ZSTD_c_experimentalParam13 = 1010
    ZSTD_c_experimentalParam14 = 1011
    ZSTD_c_experimentalParam15 = 1012
    ZSTD_c_experimentalParam16 = 1013
    ZSTD_c_experimentalParam17 = 1014
    ZSTD_c_experimentalParam18 = 1015
    ZSTD_c_experimentalParam19 = 1016
end

struct ZSTD_bounds
    error::Csize_t
    lowerBound::Cint
    upperBound::Cint
end

function ZSTD_cParam_getBounds(cParam)
    ccall((:ZSTD_cParam_getBounds, libzstd), ZSTD_bounds, (ZSTD_cParameter,), cParam)
end

function ZSTD_CCtx_setParameter(cctx, param, value)
    ccall((:ZSTD_CCtx_setParameter, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, ZSTD_cParameter, Cint), cctx, param, value)
end

function ZSTD_CCtx_setPledgedSrcSize(cctx, pledgedSrcSize)
    ccall((:ZSTD_CCtx_setPledgedSrcSize, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Culonglong), cctx, pledgedSrcSize)
end

@enum ZSTD_ResetDirective::UInt32 begin
    ZSTD_reset_session_only = 1
    ZSTD_reset_parameters = 2
    ZSTD_reset_session_and_parameters = 3
end

function ZSTD_CCtx_reset(cctx, reset)
    ccall((:ZSTD_CCtx_reset, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, ZSTD_ResetDirective), cctx, reset)
end

function ZSTD_compress2(cctx, dst, dstCapacity, src, srcSize)
    ccall((:ZSTD_compress2, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t), cctx, dst, dstCapacity, src, srcSize)
end

@enum ZSTD_dParameter::UInt32 begin
    ZSTD_d_windowLogMax = 100
    ZSTD_d_experimentalParam1 = 1000
    ZSTD_d_experimentalParam2 = 1001
    ZSTD_d_experimentalParam3 = 1002
    ZSTD_d_experimentalParam4 = 1003
    ZSTD_d_experimentalParam5 = 1004
    ZSTD_d_experimentalParam6 = 1005
end

function ZSTD_dParam_getBounds(dParam)
    ccall((:ZSTD_dParam_getBounds, libzstd), ZSTD_bounds, (ZSTD_dParameter,), dParam)
end

function ZSTD_DCtx_setParameter(dctx, param, value)
    ccall((:ZSTD_DCtx_setParameter, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, ZSTD_dParameter, Cint), dctx, param, value)
end

function ZSTD_DCtx_reset(dctx, reset)
    ccall((:ZSTD_DCtx_reset, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, ZSTD_ResetDirective), dctx, reset)
end

mutable struct ZSTD_inBuffer_s
    src::Ptr{Cvoid}
    size::Csize_t
    pos::Csize_t
end

const ZSTD_inBuffer = ZSTD_inBuffer_s

mutable struct ZSTD_outBuffer_s
    dst::Ptr{Cvoid}
    size::Csize_t
    pos::Csize_t
end

const ZSTD_outBuffer = ZSTD_outBuffer_s

const ZSTD_CStream = ZSTD_CCtx

function ZSTD_createCStream()
    ccall((:ZSTD_createCStream, libzstd), Ptr{ZSTD_CStream}, ())
end

function ZSTD_freeCStream(zcs)
    ccall((:ZSTD_freeCStream, libzstd), Csize_t, (Ptr{ZSTD_CStream},), zcs)
end

@enum ZSTD_EndDirective::UInt32 begin
    ZSTD_e_continue = 0
    ZSTD_e_flush = 1
    ZSTD_e_end = 2
end

function ZSTD_compressStream2(cctx, output, input, endOp)
    ccall((:ZSTD_compressStream2, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{ZSTD_outBuffer}, Ptr{ZSTD_inBuffer}, ZSTD_EndDirective), cctx, output, input, endOp)
end

function ZSTD_CStreamInSize()
    ccall((:ZSTD_CStreamInSize, libzstd), Csize_t, ())
end

function ZSTD_CStreamOutSize()
    ccall((:ZSTD_CStreamOutSize, libzstd), Csize_t, ())
end

function ZSTD_initCStream(zcs, compressionLevel)
    ccall((:ZSTD_initCStream, libzstd), Csize_t, (Ptr{ZSTD_CStream}, Cint), zcs, compressionLevel)
end

function ZSTD_compressStream(zcs, output, input)
    ccall((:ZSTD_compressStream, libzstd), Csize_t, (Ptr{ZSTD_CStream}, Ptr{ZSTD_outBuffer}, Ptr{ZSTD_inBuffer}), zcs, output, input)
end

function ZSTD_flushStream(zcs, output)
    ccall((:ZSTD_flushStream, libzstd), Csize_t, (Ptr{ZSTD_CStream}, Ptr{ZSTD_outBuffer}), zcs, output)
end

function ZSTD_endStream(zcs, output)
    ccall((:ZSTD_endStream, libzstd), Csize_t, (Ptr{ZSTD_CStream}, Ptr{ZSTD_outBuffer}), zcs, output)
end

const ZSTD_DStream = ZSTD_DCtx

function ZSTD_createDStream()
    ccall((:ZSTD_createDStream, libzstd), Ptr{ZSTD_DStream}, ())
end

function ZSTD_freeDStream(zds)
    ccall((:ZSTD_freeDStream, libzstd), Csize_t, (Ptr{ZSTD_DStream},), zds)
end

function ZSTD_initDStream(zds)
    ccall((:ZSTD_initDStream, libzstd), Csize_t, (Ptr{ZSTD_DStream},), zds)
end

function ZSTD_decompressStream(zds, output, input)
    ccall((:ZSTD_decompressStream, libzstd), Csize_t, (Ptr{ZSTD_DStream}, Ptr{ZSTD_outBuffer}, Ptr{ZSTD_inBuffer}), zds, output, input)
end

function ZSTD_DStreamInSize()
    ccall((:ZSTD_DStreamInSize, libzstd), Csize_t, ())
end

function ZSTD_DStreamOutSize()
    ccall((:ZSTD_DStreamOutSize, libzstd), Csize_t, ())
end

function ZSTD_compress_usingDict(ctx, dst, dstCapacity, src, srcSize, dict, dictSize, compressionLevel)
    ccall((:ZSTD_compress_usingDict, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Cint), ctx, dst, dstCapacity, src, srcSize, dict, dictSize, compressionLevel)
end

function ZSTD_decompress_usingDict(dctx, dst, dstCapacity, src, srcSize, dict, dictSize)
    ccall((:ZSTD_decompress_usingDict, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t), dctx, dst, dstCapacity, src, srcSize, dict, dictSize)
end

mutable struct ZSTD_CDict_s end

const ZSTD_CDict = ZSTD_CDict_s

function ZSTD_createCDict(dictBuffer, dictSize, compressionLevel)
    ccall((:ZSTD_createCDict, libzstd), Ptr{ZSTD_CDict}, (Ptr{Cvoid}, Csize_t, Cint), dictBuffer, dictSize, compressionLevel)
end

function ZSTD_freeCDict(CDict)
    ccall((:ZSTD_freeCDict, libzstd), Csize_t, (Ptr{ZSTD_CDict},), CDict)
end

function ZSTD_compress_usingCDict(cctx, dst, dstCapacity, src, srcSize, cdict)
    ccall((:ZSTD_compress_usingCDict, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Ptr{ZSTD_CDict}), cctx, dst, dstCapacity, src, srcSize, cdict)
end

mutable struct ZSTD_DDict_s end

const ZSTD_DDict = ZSTD_DDict_s

function ZSTD_createDDict(dictBuffer, dictSize)
    ccall((:ZSTD_createDDict, libzstd), Ptr{ZSTD_DDict}, (Ptr{Cvoid}, Csize_t), dictBuffer, dictSize)
end

function ZSTD_freeDDict(ddict)
    ccall((:ZSTD_freeDDict, libzstd), Csize_t, (Ptr{ZSTD_DDict},), ddict)
end

function ZSTD_decompress_usingDDict(dctx, dst, dstCapacity, src, srcSize, ddict)
    ccall((:ZSTD_decompress_usingDDict, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Ptr{ZSTD_DDict}), dctx, dst, dstCapacity, src, srcSize, ddict)
end

function ZSTD_getDictID_fromDict(dict, dictSize)
    ccall((:ZSTD_getDictID_fromDict, libzstd), Cuint, (Ptr{Cvoid}, Csize_t), dict, dictSize)
end

function ZSTD_getDictID_fromCDict(cdict)
    ccall((:ZSTD_getDictID_fromCDict, libzstd), Cuint, (Ptr{ZSTD_CDict},), cdict)
end

function ZSTD_getDictID_fromDDict(ddict)
    ccall((:ZSTD_getDictID_fromDDict, libzstd), Cuint, (Ptr{ZSTD_DDict},), ddict)
end

function ZSTD_getDictID_fromFrame(src, srcSize)
    ccall((:ZSTD_getDictID_fromFrame, libzstd), Cuint, (Ptr{Cvoid}, Csize_t), src, srcSize)
end

function ZSTD_CCtx_loadDictionary(cctx, dict, dictSize)
    ccall((:ZSTD_CCtx_loadDictionary, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t), cctx, dict, dictSize)
end

function ZSTD_CCtx_refCDict(cctx, cdict)
    ccall((:ZSTD_CCtx_refCDict, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{ZSTD_CDict}), cctx, cdict)
end

function ZSTD_CCtx_refPrefix(cctx, prefix, prefixSize)
    ccall((:ZSTD_CCtx_refPrefix, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t), cctx, prefix, prefixSize)
end

function ZSTD_DCtx_loadDictionary(dctx, dict, dictSize)
    ccall((:ZSTD_DCtx_loadDictionary, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t), dctx, dict, dictSize)
end

function ZSTD_DCtx_refDDict(dctx, ddict)
    ccall((:ZSTD_DCtx_refDDict, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{ZSTD_DDict}), dctx, ddict)
end

function ZSTD_DCtx_refPrefix(dctx, prefix, prefixSize)
    ccall((:ZSTD_DCtx_refPrefix, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t), dctx, prefix, prefixSize)
end

function ZSTD_sizeof_CCtx(cctx)
    ccall((:ZSTD_sizeof_CCtx, libzstd), Csize_t, (Ptr{ZSTD_CCtx},), cctx)
end

function ZSTD_sizeof_DCtx(dctx)
    ccall((:ZSTD_sizeof_DCtx, libzstd), Csize_t, (Ptr{ZSTD_DCtx},), dctx)
end

function ZSTD_sizeof_CStream(zcs)
    ccall((:ZSTD_sizeof_CStream, libzstd), Csize_t, (Ptr{ZSTD_CStream},), zcs)
end

function ZSTD_sizeof_DStream(zds)
    ccall((:ZSTD_sizeof_DStream, libzstd), Csize_t, (Ptr{ZSTD_DStream},), zds)
end

function ZSTD_sizeof_CDict(cdict)
    ccall((:ZSTD_sizeof_CDict, libzstd), Csize_t, (Ptr{ZSTD_CDict},), cdict)
end

function ZSTD_sizeof_DDict(ddict)
    ccall((:ZSTD_sizeof_DDict, libzstd), Csize_t, (Ptr{ZSTD_DDict},), ddict)
end

@enum ZSTD_ErrorCode::UInt32 begin
    ZSTD_error_no_error = 0
    ZSTD_error_GENERIC = 1
    ZSTD_error_prefix_unknown = 10
    ZSTD_error_version_unsupported = 12
    ZSTD_error_frameParameter_unsupported = 14
    ZSTD_error_frameParameter_windowTooLarge = 16
    ZSTD_error_corruption_detected = 20
    ZSTD_error_checksum_wrong = 22
    ZSTD_error_literals_headerWrong = 24
    ZSTD_error_dictionary_corrupted = 30
    ZSTD_error_dictionary_wrong = 32
    ZSTD_error_dictionaryCreation_failed = 34
    ZSTD_error_parameter_unsupported = 40
    ZSTD_error_parameter_combination_unsupported = 41
    ZSTD_error_parameter_outOfBound = 42
    ZSTD_error_tableLog_tooLarge = 44
    ZSTD_error_maxSymbolValue_tooLarge = 46
    ZSTD_error_maxSymbolValue_tooSmall = 48
    ZSTD_error_stabilityCondition_notRespected = 50
    ZSTD_error_stage_wrong = 60
    ZSTD_error_init_missing = 62
    ZSTD_error_memory_allocation = 64
    ZSTD_error_workSpace_tooSmall = 66
    ZSTD_error_dstSize_tooSmall = 70
    ZSTD_error_srcSize_wrong = 72
    ZSTD_error_dstBuffer_null = 74
    ZSTD_error_noForwardProgress_destFull = 80
    ZSTD_error_noForwardProgress_inputEmpty = 82
    ZSTD_error_frameIndex_tooLarge = 100
    ZSTD_error_seekableIO = 102
    ZSTD_error_dstBuffer_wrong = 104
    ZSTD_error_srcBuffer_wrong = 105
    ZSTD_error_sequenceProducer_failed = 106
    ZSTD_error_externalSequences_invalid = 107
    ZSTD_error_maxCode = 120
end

function ZSTD_getErrorCode(functionResult)
    ccall((:ZSTD_getErrorCode, libzstd), ZSTD_ErrorCode, (Csize_t,), functionResult)
end

function ZSTD_getErrorString(code)
    ccall((:ZSTD_getErrorString, libzstd), Ptr{Cchar}, (ZSTD_ErrorCode,), code)
end

const ZDICTLIB_VISIBLE = nothing

const ZDICTLIB_HIDDEN = nothing

const ZDICTLIB_API = ZDICTLIB_VISIBLE

const ZSTDLIB_VISIBLE = nothing

const ZSTDLIB_HIDDEN = nothing

const ZSTDLIB_API = ZSTDLIB_VISIBLE

const ZSTD_VERSION_MAJOR = 1

const ZSTD_VERSION_MINOR = 5

const ZSTD_VERSION_RELEASE = 6

const ZSTD_VERSION_NUMBER = ZSTD_VERSION_MAJOR * 100 * 100 + ZSTD_VERSION_MINOR * 100 + ZSTD_VERSION_RELEASE

const ZSTD_LIB_VERSION = VersionNumber(ZSTD_VERSION_MAJOR, ZSTD_VERSION_MINOR, ZSTD_VERSION_RELEASE)

const ZSTD_VERSION_STRING = ZSTD_EXPAND_AND_QUOTE(ZSTD_LIB_VERSION)

const ZSTD_CLEVEL_DEFAULT = 3

const ZSTD_MAGICNUMBER = 0xfd2fb528

const ZSTD_MAGIC_DICTIONARY = 0xec30a437

const ZSTD_MAGIC_SKIPPABLE_START = 0x184d2a50

const ZSTD_MAGIC_SKIPPABLE_MASK = 0xfffffff0

const ZSTD_BLOCKSIZELOG_MAX = 17

const ZSTD_BLOCKSIZE_MAX = 1 << ZSTD_BLOCKSIZELOG_MAX

const ZSTD_CONTENTSIZE_UNKNOWN = Culonglong(0) - 1

const ZSTD_CONTENTSIZE_ERROR = Culonglong(0) - 2

const ZSTD_MAX_INPUT_SIZE = nothing

const ZSTDERRORLIB_VISIBLE = nothing

const ZSTDERRORLIB_HIDDEN = nothing

const ZSTDERRORLIB_API = ZSTDERRORLIB_VISIBLE

# exports
const PREFIXES = ["ZSTD_", "ZDICT_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
