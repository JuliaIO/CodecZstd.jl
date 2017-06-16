CodecZstd.jl
============

[![TravisCI Status][travisci-img]][travisci-url]
[![AppVeyor Status][appveyor-img]][appveyor-url]
[![codecov.io][codecov-img]][codecov-url]

This package exports following codecs and streams:

| Codec               | Stream                    |
| ------------------- | ------------------------- |
| `ZstdCompression`   | `ZstdCompressionStream`   |
| `ZstdDecompression` | `ZstdDecompressionStream` |

See docstrings and [TranscodingStreams.jl](https://github.com/bicycle1885/TranscodingStreams.jl) for details.

[travisci-img]: https://travis-ci.org/bicycle1885/CodecZstd.jl.svg?branch=master
[travisci-url]: https://travis-ci.org/bicycle1885/CodecZstd.jl
[appveyor-img]: https://ci.appveyor.com/api/projects/status/u58v32yenqf19x2a?svg=true
[appveyor-url]: https://ci.appveyor.com/project/bicycle1885/codeczstd-jl
[codecov-img]: http://codecov.io/github/bicycle1885/CodecZstd.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/bicycle1885/CodecZstd.jl?branch=master
