using CodecZstd
using Base.Test
import TranscodingStreams

const testdir = dirname(@__FILE__)

@testset "Zstd Codec" begin
    file = open(joinpath(testdir, "foo.txt.zst"))
    stream = ZstdDecompressionStream(file)
    @test read(stream) == b"foo"
    close(stream)

    TranscodingStreams.test_roundtrip_read(ZstdCompressionStream, ZstdDecompressionStream)
    TranscodingStreams.test_roundtrip_write(ZstdCompressionStream, ZstdDecompressionStream)
    TranscodingStreams.test_roundtrip_transcode(ZstdCompression, ZstdDecompression)
end
