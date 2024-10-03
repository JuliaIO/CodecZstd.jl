using CodecZstd
using Random
using TranscodingStreams
using TestsForCodecPackages:
    test_roundtrip_read,
    test_roundtrip_write,
    test_roundtrip_transcode,
    test_roundtrip_lines,
    test_roundtrip_seekstart
using Test

Random.seed!(1234)

include("utils.jl")

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

    @testset "Truncated frames" begin
        # issue #24
        @test_throws ErrorException transcode(ZstdDecompressor, UInt8[])
        for trial in 1:1000
            local uncompressed_data = rand(UInt8, rand(0:100))
            local compressed_data = transcode(ZstdCompressor, uncompressed_data)
            local L = length(compressed_data)
            for n in 0:L-1
                @test_throws ErrorException transcode(ZstdDecompressor, compressed_data[1:n])
            end
            @test transcode(ZstdDecompressor, compressed_data) == uncompressed_data
        end
    end

    @testset "skippable frames" begin
        skippable_frame = create_skippable_frame(b"\r\0\0\0")
        u1 = collect(b"")
        u2 = collect(b"Hello World!")
        c1 = transcode(ZstdCompressor, u1)
        c2 = transcode(ZstdCompressor, u2)
        @test transcode(ZstdDecompressor, skippable_frame) == UInt8[]
        @test transcode(ZstdDecompressor, [skippable_frame; c1;]) == u1
        @test transcode(ZstdDecompressor, [skippable_frame; c2;]) == u2
    end

    @test ZstdCompressorStream <: TranscodingStreams.TranscodingStream
    @test ZstdDecompressorStream <: TranscodingStreams.TranscodingStream

    test_roundtrip_read(ZstdCompressorStream, ZstdDecompressorStream)
    test_roundtrip_write(ZstdCompressorStream, ZstdDecompressorStream)
    test_roundtrip_lines(ZstdCompressorStream, ZstdDecompressorStream)
    test_roundtrip_transcode(ZstdCompressor, ZstdDecompressor)
    test_roundtrip_seekstart(ZstdCompressorStream, ZstdDecompressorStream)

    frame_encoder = io -> TranscodingStream(ZstdFrameCompressor(), io)
    test_roundtrip_read(frame_encoder, ZstdDecompressorStream)
    test_roundtrip_write(frame_encoder, ZstdDecompressorStream)
    test_roundtrip_lines(frame_encoder, ZstdDecompressorStream)
    test_roundtrip_transcode(ZstdFrameCompressor, ZstdDecompressor)
    test_roundtrip_seekstart(frame_encoder, ZstdDecompressorStream)

    @testset "ZstdFrameCompressor streaming edge case" begin
        codec = ZstdFrameCompressor()
        TranscodingStreams.initialize(codec)
        e = TranscodingStreams.Error()
        r = TranscodingStreams.startproc(codec, :write, e)
        @test r == :ok
        # data buffers
        data = rand(UInt8, 32*1024*1024)
        buffer1 = copy(data)
        buffer2 = zeros(UInt8, length(data)*2)
        GC.@preserve buffer1 buffer2 begin
            total_out = 0
            total_in = 0
            while total_in < length(data) || r != :end
                in_size = min(length(buffer1) - total_in, 1024*1024)
                out_size = min(length(buffer2) - total_out, 1024)
                input = TranscodingStreams.Memory(pointer(buffer1, total_in + 1), UInt(in_size))
                output = TranscodingStreams.Memory(pointer(buffer2, total_out + 1), UInt(out_size))
                Δin, Δout, r = TranscodingStreams.process(codec, input, output, e)
                if r == :error
                    throw(e[])
                end
                total_out += Δout
                total_in += Δin
            end
            @test r == :end
        end
        TranscodingStreams.finalize(codec)
        resize!(buffer2, total_out)
        @test transcode(ZstdDecompressor, buffer2) == data
    end

    @testset "find_decompressed_size" begin
        codec = ZstdFrameCompressor
        buffer1 = transcode(codec, b"Hello")
        buffer2 = transcode(codec, b"World!")
        @test CodecZstd.find_decompressed_size(buffer1) == 5
        @test CodecZstd.find_decompressed_size(buffer2) == 6

        iob = IOBuffer()
        write(iob, buffer1)
        write(iob, buffer2)
        v = take!(iob)
        @test CodecZstd.find_decompressed_size(v) == 11

        write(iob, buffer1)
        write(iob, buffer1)
        write(iob, buffer1)
        v = take!(iob)
        @test CodecZstd.find_decompressed_size(v) == 15

        write(iob, buffer1)
        write(iob, buffer2)
        write(iob, buffer1)
        write(iob, buffer2)
        v = take!(iob)
        @test CodecZstd.find_decompressed_size(v) == 22

        codec = ZstdCompressor
        buffer3 = transcode(codec, b"Hello")
        buffer4 = transcode(codec, b"World!")
        @test CodecZstd.find_decompressed_size(buffer3) == CodecZstd.ZSTD_CONTENTSIZE_UNKNOWN
        @test CodecZstd.find_decompressed_size(buffer4) == CodecZstd.ZSTD_CONTENTSIZE_UNKNOWN

        write(iob, buffer1)
        write(iob, buffer2)
        write(iob, buffer3)
        write(iob, buffer4)
        v = take!(iob)
        GC.@preserve v begin
            @test CodecZstd.find_decompressed_size(pointer(v), length(buffer1)) == 5
            @test CodecZstd.find_decompressed_size(pointer(v), length(buffer1)+length(buffer2)) == 11
            @test CodecZstd.find_decompressed_size(pointer(v), length(buffer1)+length(buffer2)-1) == CodecZstd.ZSTD_CONTENTSIZE_ERROR
        end
        @test CodecZstd.find_decompressed_size(v) == CodecZstd.ZSTD_CONTENTSIZE_UNKNOWN

        write(iob, buffer1)
        write(iob, "George Washington")
        v = take!(iob)
        GC.@preserve v begin
            @test CodecZstd.find_decompressed_size(pointer(v), length(buffer1)) == 5
        end
        @test CodecZstd.find_decompressed_size(v) == CodecZstd.ZSTD_CONTENTSIZE_ERROR
    end

    include("compress_endOp.jl")
    include("static_only_tests.jl")

    @testset "reusing a compressor" begin
        compressor = ZstdCompressor()
        x = rand(UInt8, 1000)
        TranscodingStreams.initialize(compressor)
        ret1 = transcode(compressor, x)
        TranscodingStreams.finalize(compressor)

        # compress again using the same compressor
        TranscodingStreams.initialize(compressor) # segfault happens here!
        ret2 = transcode(compressor, x)
        ret3 = transcode(compressor, x)
        TranscodingStreams.finalize(compressor)

        @test transcode(ZstdDecompressor, ret1) == x
        @test transcode(ZstdDecompressor, ret2) == x
        @test transcode(ZstdDecompressor, ret3) == x
        @test ret1 == ret2
        @test ret1 == ret3

        decompressor = ZstdDecompressor()
        TranscodingStreams.initialize(decompressor)
        @test transcode(decompressor, ret1) == x
        TranscodingStreams.finalize(decompressor)

        TranscodingStreams.initialize(decompressor)
        @test transcode(decompressor, ret1) == x
        TranscodingStreams.finalize(decompressor)
    end

    @testset "use after free doesn't segfault" begin
        @testset "$(Codec)" for Codec in (ZstdCompressor, ZstdDecompressor)
            codec = Codec()
            TranscodingStreams.initialize(codec)
            TranscodingStreams.finalize(codec)
            data = [0x00,0x01]
            GC.@preserve data let m = TranscodingStreams.Memory(pointer(data), length(data))
                try
                    TranscodingStreams.expectedsize(codec, m)
                catch
                end
                try
                    TranscodingStreams.minoutsize(codec, m)
                catch
                end
                try
                    TranscodingStreams.initialize(codec)
                catch
                end
                try
                    TranscodingStreams.process(codec, m, m, TranscodingStreams.Error())
                catch
                end
                try
                    TranscodingStreams.startproc(codec, :read, TranscodingStreams.Error())
                catch
                end
                try
                    TranscodingStreams.process(codec, m, m, TranscodingStreams.Error())
                catch
                end
                try
                    TranscodingStreams.finalize(codec)
                catch
                end
            end
        end
    end
end
