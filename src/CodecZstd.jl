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

# TODO: This method will be added in the next version of TranscodingStreams.jl.
function splitkwargs(kwargs, keys)
    hits = []
    others = []
    for kwarg in kwargs
        push!(kwarg[1] ∈ keys ? hits : others, kwarg)
    end
    return hits, others
end

include("libzstd.jl")
include("compression.jl")
include("decompression.jl")

# Deprecations
@deprecate ZstdCompression         ZstdCompressor
@deprecate ZstdCompressionStream   ZstdCompressorStream
@deprecate ZstdDecompression       ZstdDecompressor
@deprecate ZstdDecompressionStream ZstdDecompressorStream

end # module
