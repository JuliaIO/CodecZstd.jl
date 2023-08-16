CodecZstd.jl
============

[![codecov.io][codecov-img]][codecov-url]

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

| Codec              | Stream                   |
| ------------------ | ------------------------ |
| `ZstdCompressor`   | `ZstdCompressorStream`   |
| `ZstdDecompressor` | `ZstdDecompressorStream` |

See docstrings and [TranscodingStreams.jl](https://github.com/bicycle1885/TranscodingStreams.jl) for details.

[travisci-img]: https://travis-ci.org/bicycle1885/CodecZstd.jl.svg?branch=master
[travisci-url]: https://travis-ci.org/bicycle1885/CodecZstd.jl
[appveyor-img]: https://ci.appveyor.com/api/projects/status/u58v32yenqf19x2a?svg=true
[appveyor-url]: https://ci.appveyor.com/project/bicycle1885/codeczstd-jl
[codecov-img]: http://codecov.io/github/bicycle1885/CodecZstd.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/bicycle1885/CodecZstd.jl?branch=master
