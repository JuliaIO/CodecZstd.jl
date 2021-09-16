const ZDICTLIB_VISIBILITY = nothing
const ZSTDLIB_VISIBILITY = nothing
const ZSTDERRORLIB_VISIBILITY = nothing
const INT_MAX = typemax(Cint)

ZSTD_LIB_VERSION = quote
    ZSTD_VERSION_MAJOR, ZSTD_VERSION_MINOR, ZSTD_VERSION_RELEASE
end

function ZSTD_EXPAND_AND_QUOTE(expr)
    v = eval(expr)
    join(string.(v),".")
end