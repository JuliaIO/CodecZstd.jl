using CodecZstd
using Base.Test
import TranscodingStreams: test_roundtrip_read, test_roundtrip_write

const testdir = dirname(@__FILE__)

@testset "Zstd Codec" begin
    file = open(joinpath(testdir, "foo.txt.zst"))
    stream = ZstdDecompressionStream(file)
    @test read(stream) == b"foo"
    close(stream)

    test_roundtrip_read(ZstdCompressionStream, ZstdDecompressionStream)
    test_roundtrip_write(ZstdCompressionStream, ZstdDecompressionStream)
end
