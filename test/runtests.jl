using CodecZstd
using Base.Test

@testset "Zstd" begin
    file = IOBuffer("foo")
    stream = ZstdInflationStream(ZstdDeflationStream(file))
    @test read(stream) == b"foo"

    mktemp() do path, file
        stream = ZstdDeflationStream(ZstdInflationStream(file))
        write(stream, b"foo")
        close(stream)
        @test read(path) == b"foo"
    end
end
