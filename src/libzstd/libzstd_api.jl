# Julia wrapper for header: zdict.h
# Automatically generated using Clang.jl


function ZDICT_trainFromBuffer(dictBuffer, dictBufferCapacity, samplesBuffer, samplesSizes, nbSamples)
    ccall((:ZDICT_trainFromBuffer, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Ptr{Csize_t}, UInt32), dictBuffer, dictBufferCapacity, samplesBuffer, samplesSizes, nbSamples)
end

function ZDICT_finalizeDictionary(dstDictBuffer, maxDictSize, dictContent, dictContentSize, samplesBuffer, samplesSizes, nbSamples, parameters)
    ccall((:ZDICT_finalizeDictionary, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Ptr{Csize_t}, UInt32, ZDICT_params_t), dstDictBuffer, maxDictSize, dictContent, dictContentSize, samplesBuffer, samplesSizes, nbSamples, parameters)
end

function ZDICT_getDictID(dictBuffer, dictSize)
    ccall((:ZDICT_getDictID, libzstd), UInt32, (Ptr{Cvoid}, Csize_t), dictBuffer, dictSize)
end

function ZDICT_getDictHeaderSize(dictBuffer, dictSize)
    ccall((:ZDICT_getDictHeaderSize, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t), dictBuffer, dictSize)
end

function ZDICT_isError(errorCode)
    ccall((:ZDICT_isError, libzstd), UInt32, (Csize_t,), errorCode)
end

function ZDICT_getErrorName(errorCode)
    ccall((:ZDICT_getErrorName, libzstd), Cstring, (Csize_t,), errorCode)
end
# Julia wrapper for header: zstd.h
# Automatically generated using Clang.jl


function ZSTD_versionNumber()
    ccall((:ZSTD_versionNumber, libzstd), UInt32, ())
end

function ZSTD_versionString()
    ccall((:ZSTD_versionString, libzstd), Cstring, ())
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
    ccall((:ZSTD_isError, libzstd), UInt32, (Csize_t,), code)
end

function ZSTD_getErrorName(code)
    ccall((:ZSTD_getErrorName, libzstd), Cstring, (Csize_t,), code)
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

function ZSTD_createCCtx()
    ccall((:ZSTD_createCCtx, libzstd), Ptr{ZSTD_CCtx}, ())
end

function ZSTD_freeCCtx(cctx)
    ccall((:ZSTD_freeCCtx, libzstd), Csize_t, (Ptr{ZSTD_CCtx},), cctx)
end

function ZSTD_compressCCtx(cctx, dst, dstCapacity, src, srcSize, compressionLevel)
    ccall((:ZSTD_compressCCtx, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Cint), cctx, dst, dstCapacity, src, srcSize, compressionLevel)
end

function ZSTD_createDCtx()
    ccall((:ZSTD_createDCtx, libzstd), Ptr{ZSTD_DCtx}, ())
end

function ZSTD_freeDCtx(dctx)
    ccall((:ZSTD_freeDCtx, libzstd), Csize_t, (Ptr{ZSTD_DCtx},), dctx)
end

function ZSTD_decompressDCtx(dctx, dst, dstCapacity, src, srcSize)
    ccall((:ZSTD_decompressDCtx, libzstd), Csize_t, (Ptr{ZSTD_DCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t), dctx, dst, dstCapacity, src, srcSize)
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

function ZSTD_CCtx_reset(cctx, reset)
    ccall((:ZSTD_CCtx_reset, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, ZSTD_ResetDirective), cctx, reset)
end

function ZSTD_compress2(cctx, dst, dstCapacity, src, srcSize)
    ccall((:ZSTD_compress2, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t), cctx, dst, dstCapacity, src, srcSize)
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

function ZSTD_createCStream()
    ccall((:ZSTD_createCStream, libzstd), Ptr{ZSTD_CStream}, ())
end

function ZSTD_freeCStream(zcs)
    ccall((:ZSTD_freeCStream, libzstd), Csize_t, (Ptr{ZSTD_CStream},), zcs)
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

function ZSTD_createCDict(dictBuffer, dictSize, compressionLevel)
    ccall((:ZSTD_createCDict, libzstd), Ptr{ZSTD_CDict}, (Ptr{Cvoid}, Csize_t, Cint), dictBuffer, dictSize, compressionLevel)
end

function ZSTD_freeCDict(CDict)
    ccall((:ZSTD_freeCDict, libzstd), Csize_t, (Ptr{ZSTD_CDict},), CDict)
end

function ZSTD_compress_usingCDict(cctx, dst, dstCapacity, src, srcSize, cdict)
    ccall((:ZSTD_compress_usingCDict, libzstd), Csize_t, (Ptr{ZSTD_CCtx}, Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, Ptr{ZSTD_CDict}), cctx, dst, dstCapacity, src, srcSize, cdict)
end

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
    ccall((:ZSTD_getDictID_fromDict, libzstd), UInt32, (Ptr{Cvoid}, Csize_t), dict, dictSize)
end

function ZSTD_getDictID_fromCDict(cdict)
    ccall((:ZSTD_getDictID_fromCDict, libzstd), UInt32, (Ptr{ZSTD_CDict},), cdict)
end

function ZSTD_getDictID_fromDDict(ddict)
    ccall((:ZSTD_getDictID_fromDDict, libzstd), UInt32, (Ptr{ZSTD_DDict},), ddict)
end

function ZSTD_getDictID_fromFrame(src, srcSize)
    ccall((:ZSTD_getDictID_fromFrame, libzstd), UInt32, (Ptr{Cvoid}, Csize_t), src, srcSize)
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

function ZSTD_findDecompressedSize(src, srcSize)
    ccall((:ZSTD_findDecompressedSize, libzstd), Culonglong, (Ptr{Cvoid}, Csize_t), src, srcSize)
end

function ZSTD_decompressBound(src, srcSize)
    ccall((:ZSTD_decompressBound, libzstd), Culonglong, (Ptr{Cvoid}, Csize_t), src, srcSize)
end

function ZSTD_frameHeaderSize(src, srcSize)
    ccall((:ZSTD_frameHeaderSize, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t), src, srcSize)
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
    ccall((:ZSTD_writeSkippableFrame, libzstd), Csize_t, (Ptr{Cvoid}, Csize_t, Ptr{Cvoid}, Csize_t, UInt32), dst, dstCapacity, src, srcSize, magicVariant)
end

function ZSTD_estimateCCtxSize(compressionLevel)
    ccall((:ZSTD_estimateCCtxSize, libzstd), Csize_t, (Cint,), compressionLevel)
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

function ZSTD_estimateCStreamSize(compressionLevel)
    ccall((:ZSTD_estimateCStreamSize, libzstd), Csize_t, (Cint,), compressionLevel)
end

function ZSTD_estimateCStreamSize_usingCParams(cParams)
    ccall((:ZSTD_estimateCStreamSize_usingCParams, libzstd), Csize_t, (ZSTD_compressionParameters,), cParams)
end

function ZSTD_estimateCStreamSize_usingCCtxParams(params)
    ccall((:ZSTD_estimateCStreamSize_usingCCtxParams, libzstd), Csize_t, (Ptr{ZSTD_CCtx_params},), params)
end

function ZSTD_estimateDStreamSize(windowSize)
    ccall((:ZSTD_estimateDStreamSize, libzstd), Csize_t, (Csize_t,), windowSize)
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
    ccall((:ZSTD_isFrame, libzstd), UInt32, (Ptr{Cvoid}, Csize_t), buffer, size)
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

function ZSTD_getFrameHeader(zfhPtr, src, srcSize)
    ccall((:ZSTD_getFrameHeader, libzstd), Csize_t, (Ptr{ZSTD_frameHeader}, Ptr{Cvoid}, Csize_t), zfhPtr, src, srcSize)
end

function ZSTD_getFrameHeader_advanced(zfhPtr, src, srcSize, format)
    ccall((:ZSTD_getFrameHeader_advanced, libzstd), Csize_t, (Ptr{ZSTD_frameHeader}, Ptr{Cvoid}, Csize_t, ZSTD_format_e), zfhPtr, src, srcSize, format)
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
# Julia wrapper for header: zstd_errors.h
# Automatically generated using Clang.jl


function ZSTD_getErrorCode(functionResult)
    ccall((:ZSTD_getErrorCode, libzstd), ZSTD_ErrorCode, (Csize_t,), functionResult)
end

function ZSTD_getErrorString(code)
    ccall((:ZSTD_getErrorString, libzstd), Cstring, (ZSTD_ErrorCode,), code)
end
