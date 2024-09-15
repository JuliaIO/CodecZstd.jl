using BenchmarkTools
using Random
using TranscodingStreams
using CodecZstd

const SUITE = BenchmarkGroup()
cbench = SUITE["compression"] = BenchmarkGroup()
dbench = SUITE["decompression"] = BenchmarkGroup()

ccodec = ZstdCompressor()
dcodec = ZstdDecompressor()
TranscodingStreams.initialize(ccodec)
TranscodingStreams.initialize(dcodec)

for N in [100, 100000, 1000000]
    u1 = rand(Xoshiro(1234), UInt8, N)
    c1 = transcode(ZstdCompressor, u1)
    cbench["uncompressible"][N] = @benchmarkable transcode($ccodec, $u1)
    dbench["uncompressible"][N] = @benchmarkable transcode($dcodec, $c1)

    u2 = rand(Xoshiro(1234), 0x00:0x01, N)
    c2 = transcode(ZstdCompressor, u2)
    cbench["compressible-bytes"][N] = @benchmarkable transcode($ccodec, $u2)
    dbench["compressible-bytes"][N] = @benchmarkable transcode($dcodec, $c2)

    f = round.(randn(Xoshiro(1234), N); base=2, digits=7)
    # byte shuffle
    u3 = vec(permutedims(reinterpret(reshape, UInt8, f),(2,1)))
    c3 = transcode(ZstdCompressor, u3)
    cbench["byteshuffle"][N] = @benchmarkable transcode($ccodec, $u3)
    dbench["byteshuffle"][N] = @benchmarkable transcode($dcodec, $c3)
end