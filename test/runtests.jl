using CodecZstd
using Base.Test

const testdir = dirname(@__FILE__)

@testset "Zstd" begin
    file = open(joinpath(testdir, "foo.txt.zst"))
    stream = ZstdInflationStream(file)
    @test read(stream) == b"foo"
    close(stream)

    function test_read(data)
        file = IOBuffer(data)
        stream = ZstdInflationStream(ZstdDeflationStream(file))
        @test read(stream) == data
    end

    @testset "Read" begin
        @testset "small data" for n in 0:30
            test_read(rand(0x00:0x0f, n))
            test_read(rand(0x00:0xff, n))
        end

        @testset "large data" for n in [500, 1_000, 5_000, 10_000]
            test_read(rand(0x00:0x0f, n))
            test_read(rand(0x00:0xff, n))
        end
    end

    function test_write(data)
        mktemp() do path, file
            stream = ZstdDeflationStream(ZstdInflationStream(file))
            @test write(stream, data) == length(data)
            close(stream)
            @test read(path) == data
        end
    end

    @testset "Write" begin
        @testset "small data" for n in 0:30
            test_write(rand(0x00:0x0f, n))
            test_write(rand(0x00:0xff, n))
        end

        @testset "large data" for n in [500, 1_000, 5_000, 10_000]
            test_write(rand(0x00:0x0f, n))
            test_write(rand(0x00:0xff, n))
        end
    end
end
