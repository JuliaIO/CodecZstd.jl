module CodecZstd

export
    ZstdCompressor,
    ZstdCompressorStream,
    ZstdDecompressor,
    ZstdDecompressorStream

import TranscodingStreams:
    TranscodingStreams,
    TranscodingStream,
    Memory,
    Error,
    initialize,
    finalize,
    splitkwargs

using Zstd_jll

module LibZstd
    using CEnum
    import Zstd_jll: libzstd

    const ZDICTLIB_VISIBILITY = nothing
    const ZSTDLIB_VISIBILITY = nothing
    const ZSTDERRORLIB_VISIBILITY = nothing
    const INT_MAX = typemax(Cint)

    include(joinpath("libzstd", "libzstd_common.jl"))
    include(joinpath("libzstd", "libzstd_api.jl"))
end

include("libzstd.jl")
include("compression.jl")
include("decompression.jl")

end # module
