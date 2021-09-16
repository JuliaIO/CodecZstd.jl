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
# Julia wrapper for header: zstd_errors.h
# Automatically generated using Clang.jl


function ZSTD_getErrorCode(functionResult)
    ccall((:ZSTD_getErrorCode, libzstd), ZSTD_ErrorCode, (Csize_t,), functionResult)
end

function ZSTD_getErrorString(code)
    ccall((:ZSTD_getErrorString, libzstd), Cstring, (ZSTD_ErrorCode,), code)
end
