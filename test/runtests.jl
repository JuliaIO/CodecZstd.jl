using CodecZstd
using Base.Test
import TranscodingStreams

@testset "Zstd Codec" begin
    codec = ZstdCompression()
    @test codec isa ZstdCompression
    @test ismatch(r"^CodecZstd.ZstdCompression\(level=\d+\)$", sprint(show, codec))
    @test CodecZstd.initialize(codec) === nothing
    @test CodecZstd.finalize(codec) === nothing

    codec = ZstdDecompression()
    @test codec isa ZstdDecompression
    @test ismatch(r"^CodecZstd.ZstdDecompression\(\)$", sprint(show, codec))
    @test CodecZstd.initialize(codec) === nothing
    @test CodecZstd.finalize(codec) === nothing

    data = [0x28, 0xb5, 0x2f, 0xfd, 0x04, 0x50, 0x19, 0x00, 0x00, 0x66, 0x6f, 0x6f, 0x3f, 0xba, 0xc4, 0x59]
    @test read(ZstdDecompressionStream(IOBuffer(data))) == b"foo"
    @test read(ZstdDecompressionStream(IOBuffer(vcat(data, data)))) == b"foofoo"

    @test ZstdCompressionStream <: TranscodingStreams.TranscodingStream
    @test ZstdDecompressionStream <: TranscodingStreams.TranscodingStream

    TranscodingStreams.test_roundtrip_read(ZstdCompressionStream, ZstdDecompressionStream)
    TranscodingStreams.test_roundtrip_write(ZstdCompressionStream, ZstdDecompressionStream)
    TranscodingStreams.test_roundtrip_lines(ZstdCompressionStream, ZstdDecompressionStream)
    TranscodingStreams.test_roundtrip_transcode(ZstdCompression, ZstdDecompression)
end
