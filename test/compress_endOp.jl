using CodecZstd
using Test

@testset "compress! endOp = :continue" begin
    data = rand(1:100, 1024*1024)
    GC.@preserve data begin
        cstream = CodecZstd.CStream()
        cstream.ptr = CodecZstd.LibZstd.ZSTD_createCStream()
        cstream.ibuffer.src = pointer(data)
        cstream.ibuffer.size = sizeof(data)
        cstream.ibuffer.pos = 0
        cstream.obuffer.dst = Base.Libc.malloc(sizeof(data)*2)
        cstream.obuffer.size = sizeof(data)*2
        cstream.obuffer.pos = 0
        try
            # default endOp
            @test CodecZstd.compress!(cstream; endOp=:continue) == 0
            @test CodecZstd.find_decompressed_size(cstream.obuffer.dst, cstream.obuffer.pos) == CodecZstd.ZSTD_CONTENTSIZE_UNKNOWN
        finally
            Base.Libc.free(cstream.obuffer.dst)
        end
    end
end

@testset "compress! endOp = :flush" begin
    data = rand(1:100, 1024*1024)
    cstream = CodecZstd.CStream()
    cstream.ptr = CodecZstd.LibZstd.ZSTD_createCStream()
    cstream.ibuffer.src = pointer(data)
    cstream.ibuffer.size = sizeof(data)
    cstream.ibuffer.pos = 0
    cstream.obuffer.dst = Base.Libc.malloc(sizeof(data)*2)
    cstream.obuffer.size = sizeof(data)*2
    cstream.obuffer.pos = 0
    try
        GC.@preserve data begin
            @test CodecZstd.compress!(cstream; endOp=:flush) == 0
            @test CodecZstd.find_decompressed_size(cstream.obuffer.dst, cstream.obuffer.pos) == CodecZstd.ZSTD_CONTENTSIZE_UNKNOWN
        end
    finally
        Base.Libc.free(cstream.obuffer.dst)
    end
end

@testset "compress! endOp = :end" begin
    data = rand(1:100, 1024*1024)
    cstream = CodecZstd.CStream()
    cstream.ptr = CodecZstd.LibZstd.ZSTD_createCStream()
    cstream.ibuffer.src = pointer(data)
    cstream.ibuffer.size = sizeof(data)
    cstream.ibuffer.pos = 0
    cstream.obuffer.dst = Base.Libc.malloc(sizeof(data)*2)
    cstream.obuffer.size = sizeof(data)*2
    cstream.obuffer.pos = 0
    try
        GC.@preserve data begin
            # The frame should contain the decompressed size
            @test CodecZstd.compress!(cstream; endOp=:end) == 0
            @test CodecZstd.find_decompressed_size(cstream.obuffer.dst, cstream.obuffer.pos) == sizeof(data)
        end
    finally
        Base.Libc.free(cstream.obuffer.dst)
    end
end

@testset "ZstdFrameCompressor" begin
    data = rand(1:100, 1024*1024)
    compressed = transcode(ZstdFrameCompressor, copy(reinterpret(UInt8, data)))
    GC.@preserve compressed begin
        @test CodecZstd.find_decompressed_size(pointer(compressed), sizeof(compressed)) == sizeof(data)
    end
    @test reinterpret(Int, transcode(ZstdDecompressor, compressed)) == data
    iob = IOBuffer()
    print(iob, ZstdFrameCompressor())
    @test startswith(String(take!(iob)), "ZstdFrameCompressor")
end
