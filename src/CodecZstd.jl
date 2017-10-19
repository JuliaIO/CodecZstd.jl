__precompile__()

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
    finalize

include("libzstd.jl")
include("compression.jl")
include("decompression.jl")

# Deprecations
@deprecate ZstdCompression         ZstdCompressor
@deprecate ZstdCompressionStream   ZstdCompressorStream
@deprecate ZstdDecompression       ZstdDecompressor
@deprecate ZstdDecompressionStream ZstdDecompressorStream

end # module
