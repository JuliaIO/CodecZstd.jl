# Automatically generated using Clang.jl


# Skipping MacroDefinition: ZDICTLIB_VISIBILITY __attribute__ ( ( visibility ( "default" ) ) )

const ZDICTLIB_API = ZDICTLIB_VISIBILITY

struct ZDICT_params_t
    compressionLevel::Cint
    notificationLevel::UInt32
    dictID::UInt32
end

# Skipping MacroDefinition: ZSTDLIB_VISIBILITY __attribute__ ( ( visibility ( "default" ) ) )

const ZSTDLIB_API = ZSTDLIB_VISIBILITY
const ZSTD_VERSION_MAJOR = 1
const ZSTD_VERSION_MINOR = 5
const ZSTD_VERSION_RELEASE = 0
const ZSTD_VERSION_NUMBER = ZSTD_VERSION_MAJOR * 100 * 100 + ZSTD_VERSION_MINOR * 100 + ZSTD_VERSION_RELEASE

# Skipping MacroDefinition: ZSTD_LIB_VERSION ZSTD_VERSION_MAJOR . ZSTD_VERSION_MINOR . ZSTD_VERSION_RELEASE
# Skipping MacroDefinition: ZSTD_QUOTE ( str ) # str
# Skipping MacroDefinition: ZSTD_EXPAND_AND_QUOTE ( str ) ZSTD_QUOTE ( str )
# Skipping MacroDefinition: ZSTD_VERSION_STRING ZSTD_EXPAND_AND_QUOTE ( ZSTD_LIB_VERSION )

const ZSTD_CLEVEL_DEFAULT = 3
const ZSTD_MAGICNUMBER = 0xfd2fb528
const ZSTD_MAGIC_DICTIONARY = 0xec30a437
const ZSTD_MAGIC_SKIPPABLE_START = 0x184d2a50
const ZSTD_MAGIC_SKIPPABLE_MASK = 0xfffffff0
const ZSTD_BLOCKSIZELOG_MAX = 17
const ZSTD_BLOCKSIZE_MAX = 1 << ZSTD_BLOCKSIZELOG_MAX
const ZSTD_CONTENTSIZE_UNKNOWN = UInt64(0) - 1
const ZSTD_CONTENTSIZE_ERROR = UInt64(0) - 2

# Skipping MacroDefinition: ZSTD_COMPRESSBOUND ( srcSize ) ( ( srcSize ) + ( ( srcSize ) >> 8 ) + ( ( ( srcSize ) < ( 128 << 10 ) ) ? ( ( ( 128 << 10 ) - ( srcSize ) ) >> 11 ) /* margin, from 64 to 0 */ : 0 ) )

const ZSTD_CCtx_s = Cvoid
const ZSTD_CCtx = ZSTD_CCtx_s
const ZSTD_DCtx_s = Cvoid
const ZSTD_DCtx = ZSTD_DCtx_s

@cenum ZSTD_strategy::UInt32 begin
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

@cenum ZSTD_cParameter::UInt32 begin
    ZSTD_c_compressionLevel = 100
    ZSTD_c_windowLog = 101
    ZSTD_c_hashLog = 102
    ZSTD_c_chainLog = 103
    ZSTD_c_searchLog = 104
    ZSTD_c_minMatch = 105
    ZSTD_c_targetLength = 106
    ZSTD_c_strategy = 107
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
    ZSTD_c_experimentalParam6 = 1003
    ZSTD_c_experimentalParam7 = 1004
    ZSTD_c_experimentalParam8 = 1005
    ZSTD_c_experimentalParam9 = 1006
    ZSTD_c_experimentalParam10 = 1007
    ZSTD_c_experimentalParam11 = 1008
    ZSTD_c_experimentalParam12 = 1009
    ZSTD_c_experimentalParam13 = 1010
    ZSTD_c_experimentalParam14 = 1011
    ZSTD_c_experimentalParam15 = 1012
end


struct ZSTD_bounds
    error::Csize_t
    lowerBound::Cint
    upperBound::Cint
end

@cenum ZSTD_ResetDirective::UInt32 begin
    ZSTD_reset_session_only = 1
    ZSTD_reset_parameters = 2
    ZSTD_reset_session_and_parameters = 3
end

@cenum ZSTD_dParameter::UInt32 begin
    ZSTD_d_windowLogMax = 100
    ZSTD_d_experimentalParam1 = 1000
    ZSTD_d_experimentalParam2 = 1001
    ZSTD_d_experimentalParam3 = 1002
    ZSTD_d_experimentalParam4 = 1003
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

@cenum ZSTD_EndDirective::UInt32 begin
    ZSTD_e_continue = 0
    ZSTD_e_flush = 1
    ZSTD_e_end = 2
end


const ZSTD_DStream = ZSTD_DCtx
const ZSTD_CDict_s = Cvoid
const ZSTD_CDict = ZSTD_CDict_s
const ZSTD_DDict_s = Cvoid
const ZSTD_DDict = ZSTD_DDict_s

# Skipping MacroDefinition: ZSTDERRORLIB_VISIBILITY __attribute__ ( ( visibility ( "default" ) ) )

const ZSTDERRORLIB_API = ZSTDERRORLIB_VISIBILITY

@cenum ZSTD_ErrorCode::UInt32 begin
    ZSTD_error_no_error = 0
    ZSTD_error_GENERIC = 1
    ZSTD_error_prefix_unknown = 10
    ZSTD_error_version_unsupported = 12
    ZSTD_error_frameParameter_unsupported = 14
    ZSTD_error_frameParameter_windowTooLarge = 16
    ZSTD_error_corruption_detected = 20
    ZSTD_error_checksum_wrong = 22
    ZSTD_error_dictionary_corrupted = 30
    ZSTD_error_dictionary_wrong = 32
    ZSTD_error_dictionaryCreation_failed = 34
    ZSTD_error_parameter_unsupported = 40
    ZSTD_error_parameter_outOfBound = 42
    ZSTD_error_tableLog_tooLarge = 44
    ZSTD_error_maxSymbolValue_tooLarge = 46
    ZSTD_error_maxSymbolValue_tooSmall = 48
    ZSTD_error_stage_wrong = 60
    ZSTD_error_init_missing = 62
    ZSTD_error_memory_allocation = 64
    ZSTD_error_workSpace_tooSmall = 66
    ZSTD_error_dstSize_tooSmall = 70
    ZSTD_error_srcSize_wrong = 72
    ZSTD_error_dstBuffer_null = 74
    ZSTD_error_frameIndex_tooLarge = 100
    ZSTD_error_seekableIO = 102
    ZSTD_error_dstBuffer_wrong = 104
    ZSTD_error_srcBuffer_wrong = 105
    ZSTD_error_maxCode = 120
end

