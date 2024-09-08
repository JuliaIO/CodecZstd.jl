using Test
using CodecZstd
include("LibZstd_clang_static.jl")

"""
Zstandard has a static-only API meant for functions that may change over time.
These tests use the static-only API to test `find_decompressed_size`
"""

@testset "find_decompressed_size (with static-only API)" begin
    codec = ZstdFrameCompressor
    buffer1 = transcode(codec, b"Hello")
    buffer2 = transcode(codec, b"World!")
    LibZstdStatic.ZSTD_findDecompressedSize(b::Vector{UInt8}) = LibZstdStatic.ZSTD_findDecompressedSize(b, length(b))
    @test CodecZstd.find_decompressed_size(buffer1) == LibZstdStatic.ZSTD_findDecompressedSize(buffer1)
    @test CodecZstd.find_decompressed_size(buffer1) == 5
    @test CodecZstd.find_decompressed_size(buffer2) == LibZstdStatic.ZSTD_findDecompressedSize(buffer2)

    iob = IOBuffer()
    write(iob, buffer1)
    write(iob, buffer2)
    v = take!(iob)
    @test CodecZstd.find_decompressed_size(v) == LibZstdStatic.ZSTD_findDecompressedSize(v)

    write(iob, buffer1)
    write(iob, buffer1)
    write(iob, buffer1)
    v = take!(iob)
    @test CodecZstd.find_decompressed_size(v) == LibZstdStatic.ZSTD_findDecompressedSize(v)

    write(iob, buffer1)
    write(iob, buffer2)
    write(iob, buffer1)
    write(iob, buffer2)
    v = take!(iob)
    @test CodecZstd.find_decompressed_size(v) == LibZstdStatic.ZSTD_findDecompressedSize(v)

    codec = ZstdCompressor
    buffer3 = transcode(codec, b"Hello")
    buffer4 = transcode(codec, b"World!")
    @test CodecZstd.find_decompressed_size(buffer3) == LibZstdStatic.ZSTD_findDecompressedSize(buffer3)
    @test CodecZstd.find_decompressed_size(buffer4) == LibZstdStatic.ZSTD_findDecompressedSize(buffer4)

    write(iob, buffer1)
    write(iob, buffer2)
    write(iob, buffer3)
    write(iob, buffer4)
    v = take!(iob)
    GC.@preserve v begin
        @test CodecZstd.find_decompressed_size(pointer(v), length(buffer1)) ==
            LibZstdStatic.ZSTD_findDecompressedSize(v, length(buffer1))
        @test CodecZstd.find_decompressed_size(pointer(v), length(buffer1)+length(buffer2)) ==
            LibZstdStatic.ZSTD_findDecompressedSize(v, length(buffer1) + length(buffer2))
    end
    @test CodecZstd.find_decompressed_size(v) == LibZstdStatic.ZSTD_findDecompressedSize(v)

    write(iob, buffer1)
    write(iob, "George Washington")
    v = take!(iob)
    GC.@preserve v begin
        @test CodecZstd.find_decompressed_size(pointer(v), length(buffer1)) == LibZstdStatic.ZSTD_findDecompressedSize(v, length(buffer1))
    end
    @test CodecZstd.find_decompressed_size(v) == LibZstdStatic.ZSTD_findDecompressedSize(v)

    @testset "skippable frames" begin
        skippable_frame = create_skippable_frame(b"\r\0\0\0")
        @test CodecZstd.find_decompressed_size(skippable_frame) == LibZstdStatic.ZSTD_findDecompressedSize(skippable_frame)
        @test CodecZstd.find_decompressed_size(skippable_frame) == 0
        for d in 0:2
            v = vcat(circshift([buffer1, skippable_frame, buffer2], d)...)
            @test CodecZstd.find_decompressed_size(v) == LibZstdStatic.ZSTD_findDecompressedSize(v)
            @test CodecZstd.find_decompressed_size(v) == 11
        end
    end

end
