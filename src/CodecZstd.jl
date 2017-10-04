__precompile__()

module CodecZstd

export
    ZstdCompression,
    ZstdCompressionStream,
    ZstdDecompression,
    ZstdDecompressionStream

import TranscodingStreams:
    TranscodingStreams,
    TranscodingStream,
    Memory,
    Error,
    initialize,
    finalize

include("libzstd.jl")
include("compression.jl")
include("decompression.jl")

end # module
