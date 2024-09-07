module LibZstdStatic

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

mutable struct ZSTD_CCtx_params_s end

const ZSTD_CCtx_params = ZSTD_CCtx_params_s

struct ZSTD_Sequence
    offset::Cuint
    litLength::Cuint
    matchLength::Cuint
    rep::Cuint
end

struct ZSTD_compressionParameters
    windowLog::Cuint
    chainLog::Cuint
    hashLog::Cuint
    searchLog::Cuint
    minMatch::Cuint
    targetLength::Cuint
    strategy::ZSTD_strategy
end

struct ZSTD_frameParameters
    contentSizeFlag::Cint
    checksumFlag::Cint
    noDictIDFlag::Cint
end

struct ZSTD_parameters
    cParams::ZSTD_compressionParameters
    fParams::ZSTD_frameParameters
end

@enum ZSTD_dictContentType_e::UInt32 begin
    ZSTD_dct_auto = 0
    ZSTD_dct_rawContent = 1
    ZSTD_dct_fullDict = 2
end

@enum ZSTD_dictLoadMethod_e::UInt32 begin
    ZSTD_dlm_byCopy = 0
    ZSTD_dlm_byRef = 1
end

@enum ZSTD_format_e::UInt32 begin
    ZSTD_f_zstd1 = 0
    ZSTD_f_zstd1_magicless = 1
end

@enum ZSTD_forceIgnoreChecksum_e::UInt32 begin
    ZSTD_d_validateChecksum = 0
    ZSTD_d_ignoreChecksum = 1
end

@enum ZSTD_refMultipleDDicts_e::UInt32 begin
    ZSTD_rmd_refSingleDDict = 0
    ZSTD_rmd_refMultipleDDicts = 1
end

@enum ZSTD_dictAttachPref_e::UInt32 begin
    ZSTD_dictDefaultAttach = 0
    ZSTD_dictForceAttach = 1
    ZSTD_dictForceCopy = 2
    ZSTD_dictForceLoad = 3
end

@enum ZSTD_literalCompressionMode_e::UInt32 begin
    ZSTD_lcm_auto = 0
    ZSTD_lcm_huffman = 1
    ZSTD_lcm_uncompressed = 2
end

@enum ZSTD_paramSwitch_e::UInt32 begin
    ZSTD_ps_auto = 0
    ZSTD_ps_enable = 1
    ZSTD_ps_disable = 2
end

function ZSTD_findDecompressedSize(src, srcSize)
    ccall((:ZSTD_findDecompressedSize, libzstd), Culonglong, (Ptr{Cvoid}, Csize_t), src, srcSize)
end

function ZSTD_decompressBound(src, srcSize)
    ccall((:ZSTD_decompressBound, libzstd), Culonglong, (Ptr{Cvoid}, Csize_t), src, srcSize)
end

function ZSTD_frameHeaderSize(src, srcSize)
    ccall((:ZSTD_frameHeaderSize, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t), src, srcSize)
end

@enum ZSTD_frameType_e::UInt32 begin
    ZSTD_frame = 0
    ZSTD_skippableFrame = 1
end

struct ZSTD_frameHeader
    frameContentSize::Culonglong
    windowSize::Culonglong
    blockSizeMax::Cuint
    frameType::ZSTD_frameType_e
    headerSize::Cuint
    dictID::Cuint
    checksumFlag::Cuint
    _reserved1::Cuint
    _reserved2::Cuint
end

function ZSTD_getFrameHeader(zfhPtr, src, srcSize)
    ccall((:ZSTD_getFrameHeader, libzstd), Csize_t, (Ptr{ZSTD_frameHeader}, Ptr{Cvoid}, Csize_t), zfhPtr, src, srcSize)
end

function ZSTD_getFrameHeader_advanced(zfhPtr, src, srcSize, format)
    ccall((:ZSTD_getFrameHeader_advanced, libzstd), Csize_t, (Ptr{ZSTD_frameHeader}, Ptr{Cvoid}, Csize_t, ZSTD_format_e), zfhPtr, src, srcSize, format)
end

function ZSTD_decompressionMargin(src, srcSize)
    ccall((:ZSTD_decompressionMargin, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t), src, srcSize)
end

@enum ZSTD_sequenceFormat_e::UInt32 begin
    ZSTD_sf_noBlockDelimiters = 0
    ZSTD_sf_explicitBlockDelimiters = 1
end

function ZSTD_sequenceBound(srcSize)
    ccall((:ZSTD_sequenceBound, libzstd), Csize_t, (Csize_t,), srcSize)
end

function ZSTD_generateSequences(zc, outSeqs, outSeqsSize, src, srcSize)
    ccall((:ZSTD_generateSequences, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{ZSTD_Sequence}, Csize_t, Ptr{Cvoid}, Csize_t), zc, outSeqs, outSeqsSize, src, srcSize)
end

function ZSTD_mergeBlockDelimiters(sequences, seqsSize)
    ccall((:ZSTD_mergeBlockDelimiters, libzstd), Csize_t, (Ptr{ZSTD_Sequence}, Csize_t), sequences, seqsSize)
end

function ZSTD_compressSequences(cctx, dst, dstSize, inSeqs, inSeqsSize, src, srcSize)
    ccall((:ZSTD_compressSequences, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{ZSTD_Sequence}, Csize_t, Ptr{Cvoid}, Csize_t), cctx, dst, dstSize, inSeqs, inSeqsSize, src, srcSize)
end

function ZSTD_writeSkippableFrame(dst, dstCapacity, src, srcSize, magicVariant)
    ccall((:ZSTD_writeSkippableFrame, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Cuint), dst, dstCapacity, src, srcSize, magicVariant)
end

function ZSTD_readSkippableFrame(dst, dstCapacity, magicVariant, src, srcSize)
    ccall((:ZSTD_readSkippableFrame, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t, Ptr{Cuint}, Ptr{Cvoid}, Csize_t), dst, dstCapacity, magicVariant, src, srcSize)
end

function ZSTD_isSkippableFrame(buffer, size)
    ccall((:ZSTD_isSkippableFrame, libzstd), Cuint, (Ptr{Cvoid}, Csize_t), buffer, size)
end

function ZSTD_estimateCCtxSize(maxCompressionLevel)
    ccall((:ZSTD_estimateCCtxSize, libzstd), Csize_t, (Cint,), maxCompressionLevel)
end

function ZSTD_estimateCCtxSize_usingCParams(cParams)
    ccall((:ZSTD_estimateCCtxSize_usingCParams, libzstd), Csize_t, (ZSTD_compressionParameters,), cParams)
end

function ZSTD_estimateCCtxSize_usingCCtxParams(params)
    ccall((:ZSTD_estimateCCtxSize_usingCCtxParams, libzstd), Csize_t, (Ptr{ZSTD_CCtx_params},), params)
end

function ZSTD_estimateDCtxSize()
    ccall((:ZSTD_estimateDCtxSize, libzstd), Csize_t, ())
end

function ZSTD_estimateCStreamSize(maxCompressionLevel)
    ccall((:ZSTD_estimateCStreamSize, libzstd), Csize_t, (Cint,), maxCompressionLevel)
end

function ZSTD_estimateCStreamSize_usingCParams(cParams)
    ccall((:ZSTD_estimateCStreamSize_usingCParams, libzstd), Csize_t, (ZSTD_compressionParameters,), cParams)
end

function ZSTD_estimateCStreamSize_usingCCtxParams(params)
    ccall((:ZSTD_estimateCStreamSize_usingCCtxParams, libzstd), Csize_t, (Ptr{ZSTD_CCtx_params},), params)
end

function ZSTD_estimateDStreamSize(maxWindowSize)
    ccall((:ZSTD_estimateDStreamSize, libzstd), Csize_t, (Csize_t,), maxWindowSize)
end

function ZSTD_estimateDStreamSize_fromFrame(src, srcSize)
    ccall((:ZSTD_estimateDStreamSize_fromFrame, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t), src, srcSize)
end

function ZSTD_estimateCDictSize(dictSize, compressionLevel)
    ccall((:ZSTD_estimateCDictSize, libzstd), Csize_t, (Csize_t, Cint), dictSize, compressionLevel)
end

function ZSTD_estimateCDictSize_advanced(dictSize, cParams, dictLoadMethod)
    ccall((:ZSTD_estimateCDictSize_advanced, libzstd), Csize_t, (Csize_t, ZSTD_compressionParameters, ZSTD_dictLoadMethod_e), dictSize, cParams, dictLoadMethod)
end

function ZSTD_estimateDDictSize(dictSize, dictLoadMethod)
    ccall((:ZSTD_estimateDDictSize, libzstd), Csize_t, (Csize_t, ZSTD_dictLoadMethod_e), dictSize, dictLoadMethod)
end

function ZSTD_initStaticCCtx(workspace, workspaceSize)
    ccall((:ZSTD_initStaticCCtx, libzstd), Ptr{ZSTD_CCtx}, (Ptr{Cvoid}, Csize_t), workspace, workspaceSize)
end

function ZSTD_initStaticCStream(workspace, workspaceSize)
    ccall((:ZSTD_initStaticCStream, libzstd), Ptr{ZSTD_CStream}, (Ptr{Cvoid}, Csize_t), workspace, workspaceSize)
end

function ZSTD_initStaticDCtx(workspace, workspaceSize)
    ccall((:ZSTD_initStaticDCtx, libzstd), Ptr{ZSTD_DCtx}, (Ptr{Cvoid}, Csize_t), workspace, workspaceSize)
end

function ZSTD_initStaticDStream(workspace, workspaceSize)
    ccall((:ZSTD_initStaticDStream, libzstd), Ptr{ZSTD_DStream}, (Ptr{Cvoid}, Csize_t), workspace, workspaceSize)
end

function ZSTD_initStaticCDict(workspace, workspaceSize, dict, dictSize, dictLoadMethod, dictContentType, cParams)
    ccall((:ZSTD_initStaticCDict, libzstd), Ptr{ZSTD_CDict}, (Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, ZSTD_dictLoadMethod_e, ZSTD_dictContentType_e, ZSTD_compressionParameters), workspace, workspaceSize, dict, dictSize, dictLoadMethod, dictContentType, cParams)
end

function ZSTD_initStaticDDict(workspace, workspaceSize, dict, dictSize, dictLoadMethod, dictContentType)
    ccall((:ZSTD_initStaticDDict, libzstd), Ptr{ZSTD_DDict}, (Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, ZSTD_dictLoadMethod_e, ZSTD_dictContentType_e), workspace, workspaceSize, dict, dictSize, dictLoadMethod, dictContentType)
end

# typedef void * ( * ZSTD_allocFunction ) ( void * opaque , size_t size )
const ZSTD_allocFunction = Ptr{Cvoid}

# typedef void ( * ZSTD_freeFunction ) ( void * opaque , void * address )
const ZSTD_freeFunction = Ptr{Cvoid}

struct ZSTD_customMem
    customAlloc::ZSTD_allocFunction
    customFree::ZSTD_freeFunction
    opaque::Ptr{Cvoid}
end

function ZSTD_createCCtx_advanced(customMem)
    ccall((:ZSTD_createCCtx_advanced, libzstd), Ptr{ZSTD_CCtx}, (ZSTD_customMem,), customMem)
end

function ZSTD_createCStream_advanced(customMem)
    ccall((:ZSTD_createCStream_advanced, libzstd), Ptr{ZSTD_CStream}, (ZSTD_customMem,), customMem)
end

function ZSTD_createDCtx_advanced(customMem)
    ccall((:ZSTD_createDCtx_advanced, libzstd), Ptr{ZSTD_DCtx}, (ZSTD_customMem,), customMem)
end

function ZSTD_createDStream_advanced(customMem)
    ccall((:ZSTD_createDStream_advanced, libzstd), Ptr{ZSTD_DStream}, (ZSTD_customMem,), customMem)
end

function ZSTD_createCDict_advanced(dict, dictSize, dictLoadMethod, dictContentType, cParams, customMem)
    ccall((:ZSTD_createCDict_advanced, libzstd), Ptr{ZSTD_CDict}, (Ptr{Cvoid}, Csize_t, ZSTD_dictLoadMethod_e, ZSTD_dictContentType_e, ZSTD_compressionParameters, ZSTD_customMem), dict, dictSize, dictLoadMethod, dictContentType, cParams, customMem)
end

mutable struct POOL_ctx_s end

const ZSTD_threadPool = POOL_ctx_s

function ZSTD_createThreadPool(numThreads)
    ccall((:ZSTD_createThreadPool, libzstd), Ptr{ZSTD_threadPool}, (Csize_t,), numThreads)
end

function ZSTD_freeThreadPool(pool)
    ccall((:ZSTD_freeThreadPool, libzstd), Cvoid, (Ptr{ZSTD_threadPool},), pool)
end

function ZSTD_CCtx_refThreadPool(cctx, pool)
    ccall((:ZSTD_CCtx_refThreadPool, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{ZSTD_threadPool}), cctx, pool)
end

function ZSTD_createCDict_advanced2(dict, dictSize, dictLoadMethod, dictContentType, cctxParams, customMem)
    ccall((:ZSTD_createCDict_advanced2, libzstd), Ptr{ZSTD_CDict}, (Ptr{Cvoid}, Csize_t, ZSTD_dictLoadMethod_e, ZSTD_dictContentType_e, Ptr{ZSTD_CCtx_params}, ZSTD_customMem), dict, dictSize, dictLoadMethod, dictContentType, cctxParams, customMem)
end

function ZSTD_createDDict_advanced(dict, dictSize, dictLoadMethod, dictContentType, customMem)
    ccall((:ZSTD_createDDict_advanced, libzstd), Ptr{ZSTD_DDict}, (Ptr{Cvoid}, Csize_t, ZSTD_dictLoadMethod_e, ZSTD_dictContentType_e, ZSTD_customMem), dict, dictSize, dictLoadMethod, dictContentType, customMem)
end

function ZSTD_createCDict_byReference(dictBuffer, dictSize, compressionLevel)
    ccall((:ZSTD_createCDict_byReference, libzstd), Ptr{ZSTD_CDict}, (Ptr{Cvoid}, Csize_t, Cint), dictBuffer, dictSize, compressionLevel)
end

function ZSTD_getCParams(compressionLevel, estimatedSrcSize, dictSize)
    ccall((:ZSTD_getCParams, libzstd), ZSTD_compressionParameters, (Cint, Culonglong, Csize_t), compressionLevel, estimatedSrcSize, dictSize)
end

function ZSTD_getParams(compressionLevel, estimatedSrcSize, dictSize)
    ccall((:ZSTD_getParams, libzstd), ZSTD_parameters, (Cint, Culonglong, Csize_t), compressionLevel, estimatedSrcSize, dictSize)
end

function ZSTD_checkCParams(params)
    ccall((:ZSTD_checkCParams, libzstd), Csize_t, (ZSTD_compressionParameters,), params)
end

function ZSTD_adjustCParams(cPar, srcSize, dictSize)
    ccall((:ZSTD_adjustCParams, libzstd), ZSTD_compressionParameters, (ZSTD_compressionParameters, Culonglong, Csize_t), cPar, srcSize, dictSize)
end

function ZSTD_CCtx_setCParams(cctx, cparams)
    ccall((:ZSTD_CCtx_setCParams, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, ZSTD_compressionParameters), cctx, cparams)
end

function ZSTD_CCtx_setFParams(cctx, fparams)
    ccall((:ZSTD_CCtx_setFParams, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, ZSTD_frameParameters), cctx, fparams)
end

function ZSTD_CCtx_setParams(cctx, params)
    ccall((:ZSTD_CCtx_setParams, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, ZSTD_parameters), cctx, params)
end

function ZSTD_compress_advanced(cctx, dst, dstCapacity, src, srcSize, dict, dictSize, params)
    ccall((:ZSTD_compress_advanced, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, ZSTD_parameters), cctx, dst, dstCapacity, src, srcSize, dict, dictSize, params)
end

function ZSTD_compress_usingCDict_advanced(cctx, dst, dstCapacity, src, srcSize, cdict, fParams)
    ccall((:ZSTD_compress_usingCDict_advanced, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Ptr{ZSTD_CDict}, ZSTD_frameParameters), cctx, dst, dstCapacity, src, srcSize, cdict, fParams)
end

function ZSTD_CCtx_loadDictionary_byReference(cctx, dict, dictSize)
    ccall((:ZSTD_CCtx_loadDictionary_byReference, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t), cctx, dict, dictSize)
end

function ZSTD_CCtx_loadDictionary_advanced(cctx, dict, dictSize, dictLoadMethod, dictContentType)
    ccall((:ZSTD_CCtx_loadDictionary_advanced, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, ZSTD_dictLoadMethod_e, ZSTD_dictContentType_e), cctx, dict, dictSize, dictLoadMethod, dictContentType)
end

function ZSTD_CCtx_refPrefix_advanced(cctx, prefix, prefixSize, dictContentType)
    ccall((:ZSTD_CCtx_refPrefix_advanced, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, ZSTD_dictContentType_e), cctx, prefix, prefixSize, dictContentType)
end

function ZSTD_CCtx_getParameter(cctx, param, value)
    ccall((:ZSTD_CCtx_getParameter, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, ZSTD_cParameter, Ptr{Cint}), cctx, param, value)
end

function ZSTD_createCCtxParams()
    ccall((:ZSTD_createCCtxParams, libzstd), Ptr{ZSTD_CCtx_params}, ())
end

function ZSTD_freeCCtxParams(params)
    ccall((:ZSTD_freeCCtxParams, libzstd), Csize_t, (Ptr{ZSTD_CCtx_params},), params)
end

function ZSTD_CCtxParams_reset(params)
    ccall((:ZSTD_CCtxParams_reset, libzstd), Csize_t, (Ptr{ZSTD_CCtx_params},), params)
end

function ZSTD_CCtxParams_init(cctxParams, compressionLevel)
    ccall((:ZSTD_CCtxParams_init, libzstd), Csize_t, (Ptr{ZSTD_CCtx_params}, Cint), cctxParams, compressionLevel)
end

function ZSTD_CCtxParams_init_advanced(cctxParams, params)
    ccall((:ZSTD_CCtxParams_init_advanced, libzstd), Csize_t, (Ptr{ZSTD_CCtx_params}, ZSTD_parameters), cctxParams, params)
end

function ZSTD_CCtxParams_setParameter(params, param, value)
    ccall((:ZSTD_CCtxParams_setParameter, libzstd), Csize_t, (Ptr{ZSTD_CCtx_params}, ZSTD_cParameter, Cint), params, param, value)
end

function ZSTD_CCtxParams_getParameter(params, param, value)
    ccall((:ZSTD_CCtxParams_getParameter, libzstd), Csize_t, (Ptr{ZSTD_CCtx_params}, ZSTD_cParameter, Ptr{Cint}), params, param, value)
end

function ZSTD_CCtx_setParametersUsingCCtxParams(cctx, params)
    ccall((:ZSTD_CCtx_setParametersUsingCCtxParams, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{ZSTD_CCtx_params}), cctx, params)
end

function ZSTD_compressStream2_simpleArgs(cctx, dst, dstCapacity, dstPos, src, srcSize, srcPos, endOp)
    ccall((:ZSTD_compressStream2_simpleArgs, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Csize_t}, Ptr{Cvoid}, Csize_t, Ptr{Csize_t}, ZSTD_EndDirective), cctx, dst, dstCapacity, dstPos, src, srcSize, srcPos, endOp)
end

function ZSTD_isFrame(buffer, size)
    ccall((:ZSTD_isFrame, libzstd), Cuint, (Ptr{Cvoid}, Csize_t), buffer, size)
end

function ZSTD_createDDict_byReference(dictBuffer, dictSize)
    ccall((:ZSTD_createDDict_byReference, libzstd), Ptr{ZSTD_DDict}, (Ptr{Cvoid}, Csize_t), dictBuffer, dictSize)
end

function ZSTD_DCtx_loadDictionary_byReference(dctx, dict, dictSize)
    ccall((:ZSTD_DCtx_loadDictionary_byReference, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t), dctx, dict, dictSize)
end

function ZSTD_DCtx_loadDictionary_advanced(dctx, dict, dictSize, dictLoadMethod, dictContentType)
    ccall((:ZSTD_DCtx_loadDictionary_advanced, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t, ZSTD_dictLoadMethod_e, ZSTD_dictContentType_e), dctx, dict, dictSize, dictLoadMethod, dictContentType)
end

function ZSTD_DCtx_refPrefix_advanced(dctx, prefix, prefixSize, dictContentType)
    ccall((:ZSTD_DCtx_refPrefix_advanced, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t, ZSTD_dictContentType_e), dctx, prefix, prefixSize, dictContentType)
end

function ZSTD_DCtx_setMaxWindowSize(dctx, maxWindowSize)
    ccall((:ZSTD_DCtx_setMaxWindowSize, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Csize_t), dctx, maxWindowSize)
end

function ZSTD_DCtx_getParameter(dctx, param, value)
    ccall((:ZSTD_DCtx_getParameter, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, ZSTD_dParameter, Ptr{Cint}), dctx, param, value)
end

function ZSTD_DCtx_setFormat(dctx, format)
    ccall((:ZSTD_DCtx_setFormat, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, ZSTD_format_e), dctx, format)
end

function ZSTD_decompressStream_simpleArgs(dctx, dst, dstCapacity, dstPos, src, srcSize, srcPos)
    ccall((:ZSTD_decompressStream_simpleArgs, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t, Ptr{Csize_t}, Ptr{Cvoid}, Csize_t, Ptr{Csize_t}), dctx, dst, dstCapacity, dstPos, src, srcSize, srcPos)
end

function ZSTD_initCStream_srcSize(zcs, compressionLevel, pledgedSrcSize)
    ccall((:ZSTD_initCStream_srcSize, libzstd), Csize_t, (Ptr{ZSTD_CStream}, Cint, Culonglong), zcs, compressionLevel, pledgedSrcSize)
end

function ZSTD_initCStream_usingDict(zcs, dict, dictSize, compressionLevel)
    ccall((:ZSTD_initCStream_usingDict, libzstd), Csize_t, (Ptr{ZSTD_CStream}, Ptr{Cvoid}, Csize_t, Cint), zcs, dict, dictSize, compressionLevel)
end

function ZSTD_initCStream_advanced(zcs, dict, dictSize, params, pledgedSrcSize)
    ccall((:ZSTD_initCStream_advanced, libzstd), Csize_t, (Ptr{ZSTD_CStream}, Ptr{Cvoid}, Csize_t, ZSTD_parameters, Culonglong), zcs, dict, dictSize, params, pledgedSrcSize)
end

function ZSTD_initCStream_usingCDict(zcs, cdict)
    ccall((:ZSTD_initCStream_usingCDict, libzstd), Csize_t, (Ptr{ZSTD_CStream}, Ptr{ZSTD_CDict}), zcs, cdict)
end

function ZSTD_initCStream_usingCDict_advanced(zcs, cdict, fParams, pledgedSrcSize)
    ccall((:ZSTD_initCStream_usingCDict_advanced, libzstd), Csize_t, (Ptr{ZSTD_CStream}, Ptr{ZSTD_CDict}, ZSTD_frameParameters, Culonglong), zcs, cdict, fParams, pledgedSrcSize)
end

function ZSTD_resetCStream(zcs, pledgedSrcSize)
    ccall((:ZSTD_resetCStream, libzstd), Csize_t, (Ptr{ZSTD_CStream}, Culonglong), zcs, pledgedSrcSize)
end

struct ZSTD_frameProgression
    ingested::Culonglong
    consumed::Culonglong
    produced::Culonglong
    flushed::Culonglong
    currentJobID::Cuint
    nbActiveWorkers::Cuint
end

function ZSTD_getFrameProgression(cctx)
    ccall((:ZSTD_getFrameProgression, libzstd), ZSTD_frameProgression, (Ptr{ZSTD_CCtx},), cctx)
end

function ZSTD_toFlushNow(cctx)
    ccall((:ZSTD_toFlushNow, libzstd), Csize_t, (Ptr{ZSTD_CCtx},), cctx)
end

function ZSTD_initDStream_usingDict(zds, dict, dictSize)
    ccall((:ZSTD_initDStream_usingDict, libzstd), Csize_t, (Ptr{ZSTD_DStream}, Ptr{Cvoid}, Csize_t), zds, dict, dictSize)
end

function ZSTD_initDStream_usingDDict(zds, ddict)
    ccall((:ZSTD_initDStream_usingDDict, libzstd), Csize_t, (Ptr{ZSTD_DStream}, Ptr{ZSTD_DDict}), zds, ddict)
end

function ZSTD_resetDStream(zds)
    ccall((:ZSTD_resetDStream, libzstd), Csize_t, (Ptr{ZSTD_DStream},), zds)
end

# typedef size_t ( * ZSTD_sequenceProducer_F ) ( void * sequenceProducerState , ZSTD_Sequence * outSeqs , size_t outSeqsCapacity , const void * src , size_t srcSize , const void * dict , size_t dictSize , int compressionLevel , size_t windowSize )
const ZSTD_sequenceProducer_F = Ptr{Cvoid}

function ZSTD_registerSequenceProducer(cctx, sequenceProducerState, sequenceProducer)
    ccall((:ZSTD_registerSequenceProducer, libzstd), Cvoid, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, ZSTD_sequenceProducer_F), cctx, sequenceProducerState, sequenceProducer)
end

function ZSTD_CCtxParams_registerSequenceProducer(params, sequenceProducerState, sequenceProducer)
    ccall((:ZSTD_CCtxParams_registerSequenceProducer, libzstd), Cvoid, (Ptr{ZSTD_CCtx_params}, Ptr{Cvoid}, ZSTD_sequenceProducer_F), params, sequenceProducerState, sequenceProducer)
end

function ZSTD_compressBegin(cctx, compressionLevel)
    ccall((:ZSTD_compressBegin, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Cint), cctx, compressionLevel)
end

function ZSTD_compressBegin_usingDict(cctx, dict, dictSize, compressionLevel)
    ccall((:ZSTD_compressBegin_usingDict, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Cint), cctx, dict, dictSize, compressionLevel)
end

function ZSTD_compressBegin_usingCDict(cctx, cdict)
    ccall((:ZSTD_compressBegin_usingCDict, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{ZSTD_CDict}), cctx, cdict)
end

function ZSTD_copyCCtx(cctx, preparedCCtx, pledgedSrcSize)
    ccall((:ZSTD_copyCCtx, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{ZSTD_CCtx}, Culonglong), cctx, preparedCCtx, pledgedSrcSize)
end

function ZSTD_compressContinue(cctx, dst, dstCapacity, src, srcSize)
    ccall((:ZSTD_compressContinue, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t), cctx, dst, dstCapacity, src, srcSize)
end

function ZSTD_compressEnd(cctx, dst, dstCapacity, src, srcSize)
    ccall((:ZSTD_compressEnd, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t), cctx, dst, dstCapacity, src, srcSize)
end

function ZSTD_compressBegin_advanced(cctx, dict, dictSize, params, pledgedSrcSize)
    ccall((:ZSTD_compressBegin_advanced, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, ZSTD_parameters, Culonglong), cctx, dict, dictSize, params, pledgedSrcSize)
end

function ZSTD_compressBegin_usingCDict_advanced(cctx, cdict, fParams, pledgedSrcSize)
    ccall((:ZSTD_compressBegin_usingCDict_advanced, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{ZSTD_CDict}, ZSTD_frameParameters, Culonglong), cctx, cdict, fParams, pledgedSrcSize)
end

function ZSTD_decodingBufferSize_min(windowSize, frameContentSize)
    ccall((:ZSTD_decodingBufferSize_min, libzstd), Csize_t, (Culonglong, Culonglong), windowSize, frameContentSize)
end

function ZSTD_decompressBegin(dctx)
    ccall((:ZSTD_decompressBegin, libzstd), Csize_t, (Ptr{ZSTD_DCtx},), dctx)
end

function ZSTD_decompressBegin_usingDict(dctx, dict, dictSize)
    ccall((:ZSTD_decompressBegin_usingDict, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t), dctx, dict, dictSize)
end

function ZSTD_decompressBegin_usingDDict(dctx, ddict)
    ccall((:ZSTD_decompressBegin_usingDDict, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{ZSTD_DDict}), dctx, ddict)
end

function ZSTD_nextSrcSizeToDecompress(dctx)
    ccall((:ZSTD_nextSrcSizeToDecompress, libzstd), Csize_t, (Ptr{ZSTD_DCtx},), dctx)
end

function ZSTD_decompressContinue(dctx, dst, dstCapacity, src, srcSize)
    ccall((:ZSTD_decompressContinue, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t), dctx, dst, dstCapacity, src, srcSize)
end

function ZSTD_copyDCtx(dctx, preparedDCtx)
    ccall((:ZSTD_copyDCtx, libzstd), Cvoid, (Ptr{ZSTD_DCtx}, Ptr{ZSTD_DCtx}), dctx, preparedDCtx)
end

@enum ZSTD_nextInputType_e::UInt32 begin
    ZSTDnit_frameHeader = 0
    ZSTDnit_blockHeader = 1
    ZSTDnit_block = 2
    ZSTDnit_lastBlock = 3
    ZSTDnit_checksum = 4
    ZSTDnit_skippableFrame = 5
end

function ZSTD_nextInputType(dctx)
    ccall((:ZSTD_nextInputType, libzstd), ZSTD_nextInputType_e, (Ptr{ZSTD_DCtx},), dctx)
end

function ZSTD_getBlockSize(cctx)
    ccall((:ZSTD_getBlockSize, libzstd), Csize_t, (Ptr{ZSTD_CCtx},), cctx)
end

function ZSTD_compressBlock(cctx, dst, dstCapacity, src, srcSize)
    ccall((:ZSTD_compressBlock, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t), cctx, dst, dstCapacity, src, srcSize)
end

function ZSTD_decompressBlock(dctx, dst, dstCapacity, src, srcSize)
    ccall((:ZSTD_decompressBlock, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t), dctx, dst, dstCapacity, src, srcSize)
end

function ZSTD_insertBlock(dctx, blockStart, blockSize)
    ccall((:ZSTD_insertBlock, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t), dctx, blockStart, blockSize)
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

const ZSTDLIB_STATIC_API = ZSTDLIB_VISIBLE

const ZSTD_FRAMEHEADERSIZE_MAX = 18

const ZSTD_SKIPPABLEHEADERSIZE = 8

const ZSTD_WINDOWLOG_MAX_32 = 30

const ZSTD_WINDOWLOG_MAX_64 = 31

const ZSTD_WINDOWLOG_MAX = if sizeof(Csize_t) == 4
            ZSTD_WINDOWLOG_MAX_32
        else
            ZSTD_WINDOWLOG_MAX_64
        end

const ZSTD_WINDOWLOG_MIN = 10

const ZSTD_HASHLOG_MAX = if ZSTD_WINDOWLOG_MAX < 30
            ZSTD_WINDOWLOG_MAX
        else
            30
        end

const ZSTD_HASHLOG_MIN = 6

const ZSTD_CHAINLOG_MAX_32 = 29

const ZSTD_CHAINLOG_MAX_64 = 30

const ZSTD_CHAINLOG_MAX = if sizeof(Csize_t) == 4
            ZSTD_CHAINLOG_MAX_32
        else
            ZSTD_CHAINLOG_MAX_64
        end

const ZSTD_CHAINLOG_MIN = ZSTD_HASHLOG_MIN

const ZSTD_SEARCHLOG_MAX = ZSTD_WINDOWLOG_MAX - 1

const ZSTD_SEARCHLOG_MIN = 1

const ZSTD_MINMATCH_MAX = 7

const ZSTD_MINMATCH_MIN = 3

const ZSTD_TARGETLENGTH_MAX = ZSTD_BLOCKSIZE_MAX

const ZSTD_TARGETLENGTH_MIN = 0

const ZSTD_STRATEGY_MIN = ZSTD_fast

const ZSTD_STRATEGY_MAX = ZSTD_btultra2

const ZSTD_BLOCKSIZE_MAX_MIN = 1 << 10

const ZSTD_OVERLAPLOG_MIN = 0

const ZSTD_OVERLAPLOG_MAX = 9

const ZSTD_WINDOWLOG_LIMIT_DEFAULT = 27

const ZSTD_LDM_HASHLOG_MIN = ZSTD_HASHLOG_MIN

const ZSTD_LDM_HASHLOG_MAX = ZSTD_HASHLOG_MAX

const ZSTD_LDM_MINMATCH_MIN = 4

const ZSTD_LDM_MINMATCH_MAX = 4096

const ZSTD_LDM_BUCKETSIZELOG_MIN = 1

const ZSTD_LDM_BUCKETSIZELOG_MAX = 8

const ZSTD_LDM_HASHRATELOG_MIN = 0

const ZSTD_LDM_HASHRATELOG_MAX = ZSTD_WINDOWLOG_MAX - ZSTD_HASHLOG_MIN

const ZSTD_TARGETCBLOCKSIZE_MIN = 1340

const ZSTD_TARGETCBLOCKSIZE_MAX = ZSTD_BLOCKSIZE_MAX

const ZSTD_SRCSIZEHINT_MIN = 0

const ZSTD_SRCSIZEHINT_MAX = INT_MAX

const ZSTD_c_rsyncable = ZSTD_c_experimentalParam1

const ZSTD_c_format = ZSTD_c_experimentalParam2

const ZSTD_c_forceMaxWindow = ZSTD_c_experimentalParam3

const ZSTD_c_forceAttachDict = ZSTD_c_experimentalParam4

const ZSTD_c_literalCompressionMode = ZSTD_c_experimentalParam5

const ZSTD_c_srcSizeHint = ZSTD_c_experimentalParam7

const ZSTD_c_enableDedicatedDictSearch = ZSTD_c_experimentalParam8

const ZSTD_c_stableInBuffer = ZSTD_c_experimentalParam9

const ZSTD_c_stableOutBuffer = ZSTD_c_experimentalParam10

const ZSTD_c_blockDelimiters = ZSTD_c_experimentalParam11

const ZSTD_c_validateSequences = ZSTD_c_experimentalParam12

const ZSTD_c_useBlockSplitter = ZSTD_c_experimentalParam13

const ZSTD_c_useRowMatchFinder = ZSTD_c_experimentalParam14

const ZSTD_c_deterministicRefPrefix = ZSTD_c_experimentalParam15

const ZSTD_c_prefetchCDictTables = ZSTD_c_experimentalParam16

const ZSTD_c_enableSeqProducerFallback = ZSTD_c_experimentalParam17

const ZSTD_c_maxBlockSize = ZSTD_c_experimentalParam18

const ZSTD_c_searchForExternalRepcodes = ZSTD_c_experimentalParam19

const ZSTD_d_format = ZSTD_d_experimentalParam1

const ZSTD_d_stableOutBuffer = ZSTD_d_experimentalParam2

const ZSTD_d_forceIgnoreChecksum = ZSTD_d_experimentalParam3

const ZSTD_d_refMultipleDDicts = ZSTD_d_experimentalParam4

const ZSTD_d_disableHuffmanAssembly = ZSTD_d_experimentalParam5

const ZSTD_d_maxBlockSize = ZSTD_d_experimentalParam6

const ZSTD_SEQUENCE_PRODUCER_ERROR = size_t(-1)

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
