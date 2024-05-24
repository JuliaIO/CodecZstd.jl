using CodecZstd
using Test

@testset "compress! endOp = :continue" begin
    data = rand(1:100, 1024*1024)
    cstream = CodecZstd.CStream()
    cstream.ibuffer.src = pointer(data)
    cstream.ibuffer.size = sizeof(data)
    cstream.ibuffer.pos = 0
    cstream.obuffer.dst = Base.Libc.malloc(sizeof(data)*2)
    cstream.obuffer.size = sizeof(data)*2
    cstream.obuffer.pos = 0
    try
        GC.@preserve data begin
            # default endOp
            @test CodecZstd.compress!(cstream; endOp=:continue) == 0
            @test CodecZstd.find_decompressed_size(cstream.obuffer.dst, cstream.obuffer.pos) == CodecZstd.ZSTD_CONTENTSIZE_UNKNOWN
        end
    finally
        Base.Libc.free(cstream.obuffer.dst)
    end
end

@testset "compress! endOp = :flush" begin
    data = rand(1:100, 1024*1024)
    cstream = CodecZstd.CStream()
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
