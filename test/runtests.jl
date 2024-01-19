using CodecZstd
using Random
using TranscodingStreams
using Test

@testset "Zstd Codec" begin
    codec = ZstdCompressor()
    @test codec isa ZstdCompressor
    @test occursin(r"^ZstdCompressor\(level=\d+\)$", sprint(show, codec))
    @test CodecZstd.initialize(codec) === nothing
    @test CodecZstd.finalize(codec) === nothing

    codec = ZstdDecompressor()
    @test codec isa ZstdDecompressor
    @test occursin(r"^ZstdDecompressor\(\)$", sprint(show, codec))
    @test CodecZstd.initialize(codec) === nothing
    @test CodecZstd.finalize(codec) === nothing

    data = [0x28, 0xb5, 0x2f, 0xfd, 0x04, 0x50, 0x19, 0x00, 0x00, 0x66, 0x6f, 0x6f, 0x3f, 0xba, 0xc4, 0x59]
    @test read(ZstdDecompressorStream(IOBuffer(data))) == b"foo"
    @test read(ZstdDecompressorStream(IOBuffer(vcat(data, data)))) == b"foofoo"

    @test ZstdCompressorStream <: TranscodingStreams.TranscodingStream
    @test ZstdDecompressorStream <: TranscodingStreams.TranscodingStream

    TranscodingStreams.test_roundtrip_read(ZstdCompressorStream, ZstdDecompressorStream)
    TranscodingStreams.test_roundtrip_write(ZstdCompressorStream, ZstdDecompressorStream)
    TranscodingStreams.test_roundtrip_lines(ZstdCompressorStream, ZstdDecompressorStream)
    TranscodingStreams.test_roundtrip_transcode(ZstdCompressor, ZstdDecompressor)
end
