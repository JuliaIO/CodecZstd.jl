CodecZstd.jl
============

[![codecov](https://codecov.io/gh/JuliaIO/CodecZstd.jl/graph/badge.svg?token=CgSrhnEKdy)](https://codecov.io/gh/JuliaIO/CodecZstd.jl)

## Installation

```julia
Pkg.add("CodecZstd")
```

## Usage

```julia
using CodecZstd

# Some text.
text = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean sollicitudin
mauris non nisi consectetur, a dapibus urna pretium. Vestibulum non posuere
erat. Donec luctus a turpis eget aliquet. Cras tristique iaculis ex, eu
malesuada sem interdum sed. Vestibulum ante ipsum primis in faucibus orci luctus
et ultrices posuere cubilia Curae; Etiam volutpat, risus nec gravida ultricies,
erat ex bibendum ipsum, sed varius ipsum ipsum vitae dui.
"""

# Streaming API.
stream = ZstdCompressorStream(IOBuffer(text))
for line in eachline(ZstdDecompressorStream(stream))
    println(line)
end
close(stream)

# Array API.
compressed = transcode(ZstdCompressor, text)
@assert sizeof(compressed) < sizeof(text)
@assert transcode(ZstdDecompressor, compressed) == Vector{UInt8}(text)
```

This package exports following codecs and streams:

| Codec                 | Stream                   |
| ------------------    | ------------------------ |
| `ZstdCompressor`      | `ZstdCompressorStream`   |
| `ZstdDecompressor`    | `ZstdDecompressorStream` |

Version 0.8.3 also introduced the virtual codec `ZstdFrameCompressor` which stores the decompressed content size in the frame header. Currently, `ZstdFrameCompressor` is an alternate constructor for `ZstdCompressor`, but that is an implementation detail which should not be relied upon.

See docstrings and [TranscodingStreams.jl](https://github.com/JuliaIO/TranscodingStreams.jl) for details.
