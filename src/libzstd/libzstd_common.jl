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
# Skipping MacroDefinition: ZSTD_DEPRECATED ( message ) ZSTDLIB_API __attribute__ ( ( deprecated ( message ) ) )
# Skipping MacroDefinition: ZSTD_FRAMEHEADERSIZE_PREFIX ( format ) ( ( format ) == ZSTD_f_zstd1 ? 5 : 1 )
# Skipping MacroDefinition: ZSTD_FRAMEHEADERSIZE_MIN ( format ) ( ( format ) == ZSTD_f_zstd1 ? 6 : 2 )

const ZSTD_FRAMEHEADERSIZE_MAX = 18
const ZSTD_SKIPPABLEHEADERSIZE = 8
const ZSTD_WINDOWLOG_MAX_32 = 30
const ZSTD_WINDOWLOG_MAX_64 = 31

# Skipping MacroDefinition: ZSTD_WINDOWLOG_MAX ( ( int ) ( sizeof ( size_t ) == 4 ? ZSTD_WINDOWLOG_MAX_32 : ZSTD_WINDOWLOG_MAX_64 ) )
const ZSTD_WINDOWLOG_MAX = sizeof(Csize_t) == 4 ? ZSTD_WINDOWLOG_MAX_32 : ZSTD_WINDOWLOG_MAX_64

const ZSTD_WINDOWLOG_MIN = 10

# Skipping MacroDefinition: ZSTD_HASHLOG_MAX ( ( ZSTD_WINDOWLOG_MAX < 30 ) ? ZSTD_WINDOWLOG_MAX : 30 )
const ZSTD_HASHLOG_MAX = ZSTD_WINDOWLOG_MAX < 30 ? ZSTD_WINDOWLOG_MAX : 30

const ZSTD_HASHLOG_MIN = 6
const ZSTD_CHAINLOG_MAX_32 = 29
const ZSTD_CHAINLOG_MAX_64 = 30

# Skipping MacroDefinition: ZSTD_CHAINLOG_MAX ( ( int ) ( sizeof ( size_t ) == 4 ? ZSTD_CHAINLOG_MAX_32 : ZSTD_CHAINLOG_MAX_64 ) )

const ZSTD_CHAINLOG_MIN = ZSTD_HASHLOG_MIN
const ZSTD_SEARCHLOG_MAX = ZSTD_WINDOWLOG_MAX - 1
const ZSTD_SEARCHLOG_MIN = 1
const ZSTD_MINMATCH_MAX = 7
const ZSTD_MINMATCH_MIN = 3
const ZSTD_TARGETLENGTH_MAX = ZSTD_BLOCKSIZE_MAX
const ZSTD_TARGETLENGTH_MIN = 0

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


const ZSTD_STRATEGY_MIN = ZSTD_fast
const ZSTD_STRATEGY_MAX = ZSTD_btultra2
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
const ZSTD_TARGETCBLOCKSIZE_MIN = 64
const ZSTD_TARGETCBLOCKSIZE_MAX = ZSTD_BLOCKSIZE_MAX
const ZSTD_SRCSIZEHINT_MIN = 0
const ZSTD_SRCSIZEHINT_MAX = INT_MAX
const ZSTD_HASHLOG3_MAX = 17

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


const ZSTD_c_rsyncable = ZSTD_c_experimentalParam1
const ZSTD_c_format = ZSTD_c_experimentalParam2
const ZSTD_c_forceMaxWindow = ZSTD_c_experimentalParam3
const ZSTD_c_forceAttachDict = ZSTD_c_experimentalParam4
const ZSTD_c_literalCompressionMode = ZSTD_c_experimentalParam5
const ZSTD_c_targetCBlockSize = ZSTD_c_experimentalParam6
const ZSTD_c_srcSizeHint = ZSTD_c_experimentalParam7
const ZSTD_c_enableDedicatedDictSearch = ZSTD_c_experimentalParam8
const ZSTD_c_stableInBuffer = ZSTD_c_experimentalParam9
const ZSTD_c_stableOutBuffer = ZSTD_c_experimentalParam10
const ZSTD_c_blockDelimiters = ZSTD_c_experimentalParam11
const ZSTD_c_validateSequences = ZSTD_c_experimentalParam12
const ZSTD_c_splitBlocks = ZSTD_c_experimentalParam13
const ZSTD_c_useRowMatchFinder = ZSTD_c_experimentalParam14
const ZSTD_c_deterministicRefPrefix = ZSTD_c_experimentalParam15

@cenum ZSTD_dParameter::UInt32 begin
    ZSTD_d_windowLogMax = 100
    ZSTD_d_experimentalParam1 = 1000
    ZSTD_d_experimentalParam2 = 1001
    ZSTD_d_experimentalParam3 = 1002
    ZSTD_d_experimentalParam4 = 1003
end


const ZSTD_d_format = ZSTD_d_experimentalParam1
const ZSTD_d_stableOutBuffer = ZSTD_d_experimentalParam2
const ZSTD_d_forceIgnoreChecksum = ZSTD_d_experimentalParam3
const ZSTD_d_refMultipleDDicts = ZSTD_d_experimentalParam4
const ZSTD_CCtx_s = Cvoid
const ZSTD_CCtx = ZSTD_CCtx_s
const ZSTD_DCtx_s = Cvoid
const ZSTD_DCtx = ZSTD_DCtx_s

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
const ZSTD_CCtx_params_s = Cvoid
const ZSTD_CCtx_params = ZSTD_CCtx_params_s

struct ZSTD_Sequence
    offset::UInt32
    litLength::UInt32
    matchLength::UInt32
    rep::UInt32
end

struct ZSTD_compressionParameters
    windowLog::UInt32
    chainLog::UInt32
    hashLog::UInt32
    searchLog::UInt32
    minMatch::UInt32
    targetLength::UInt32
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

@cenum ZSTD_dictContentType_e::UInt32 begin
    ZSTD_dct_auto = 0
    ZSTD_dct_rawContent = 1
    ZSTD_dct_fullDict = 2
end

@cenum ZSTD_dictLoadMethod_e::UInt32 begin
    ZSTD_dlm_byCopy = 0
    ZSTD_dlm_byRef = 1
end

@cenum ZSTD_format_e::UInt32 begin
    ZSTD_f_zstd1 = 0
    ZSTD_f_zstd1_magicless = 1
end

@cenum ZSTD_forceIgnoreChecksum_e::UInt32 begin
    ZSTD_d_validateChecksum = 0
    ZSTD_d_ignoreChecksum = 1
end

@cenum ZSTD_refMultipleDDicts_e::UInt32 begin
    ZSTD_rmd_refSingleDDict = 0
    ZSTD_rmd_refMultipleDDicts = 1
end

@cenum ZSTD_dictAttachPref_e::UInt32 begin
    ZSTD_dictDefaultAttach = 0
    ZSTD_dictForceAttach = 1
    ZSTD_dictForceCopy = 2
    ZSTD_dictForceLoad = 3
end

@cenum ZSTD_literalCompressionMode_e::UInt32 begin
    ZSTD_lcm_auto = 0
    ZSTD_lcm_huffman = 1
    ZSTD_lcm_uncompressed = 2
end

@cenum ZSTD_useRowMatchFinderMode_e::UInt32 begin
    ZSTD_urm_auto = 0
    ZSTD_urm_disableRowMatchFinder = 1
    ZSTD_urm_enableRowMatchFinder = 2
end

@cenum ZSTD_sequenceFormat_e::UInt32 begin
    ZSTD_sf_noBlockDelimiters = 0
    ZSTD_sf_explicitBlockDelimiters = 1
end


const ZSTD_allocFunction = Ptr{Cvoid}
const ZSTD_freeFunction = Ptr{Cvoid}

struct ZSTD_customMem
    customAlloc::ZSTD_allocFunction
    customFree::ZSTD_freeFunction
    opaque::Ptr{Cvoid}
end

const POOL_ctx_s = Cvoid
const ZSTD_threadPool = POOL_ctx_s

struct ZSTD_frameProgression
    ingested::Culonglong
    consumed::Culonglong
    produced::Culonglong
    flushed::Culonglong
    currentJobID::UInt32
    nbActiveWorkers::UInt32
end

@cenum ZSTD_frameType_e::UInt32 begin
    ZSTD_frame = 0
    ZSTD_skippableFrame = 1
end


struct ZSTD_frameHeader
    frameContentSize::Culonglong
    windowSize::Culonglong
    blockSizeMax::UInt32
    frameType::ZSTD_frameType_e
    headerSize::UInt32
    dictID::UInt32
    checksumFlag::UInt32
end

@cenum ZSTD_nextInputType_e::UInt32 begin
    ZSTDnit_frameHeader = 0
    ZSTDnit_blockHeader = 1
    ZSTDnit_block = 2
    ZSTDnit_lastBlock = 3
    ZSTDnit_checksum = 4
    ZSTDnit_skippableFrame = 5
end


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

