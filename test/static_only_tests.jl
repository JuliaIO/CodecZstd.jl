using Test
using CodecZstd
include("LibZstd_clang_static.jl")

"""
Zstandard has a static-only API meant for functions that may change over time.
These tests use the static-only API to test `find_decompressed_size` and to
count native allocations when checking context cleanup.
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

const zstd_live_allocations = Ref(0)
function tracked_zstd_alloc(::Ptr{Cvoid}, size::Csize_t)::Ptr{Cvoid}
    ptr = Base.Libc.malloc(size)
    ptr != C_NULL && (zstd_live_allocations[] += 1)
    return ptr
end
function tracked_zstd_free(::Ptr{Cvoid}, ptr::Ptr{Cvoid})::Cvoid
    ptr != C_NULL && (zstd_live_allocations[] -= 1)
    Base.Libc.free(ptr)
    return nothing
end
const tracked_zstd_memory = LibZstdStatic.ZSTD_customMem(
    @cfunction(tracked_zstd_alloc, Ptr{Cvoid}, (Ptr{Cvoid}, Csize_t)),
    @cfunction(tracked_zstd_free, Cvoid, (Ptr{Cvoid}, Ptr{Cvoid})),
    C_NULL,
)

@noinline function tracked_zstd_stream(Codec, input, explicitly_close)
    codec = Codec()
    native = if codec isa ZstdCompressor
        codec.cstream.ptr = Ptr{CodecZstd.LibZstd.ZSTD_CCtx}(
            LibZstdStatic.ZSTD_createCCtx_advanced(tracked_zstd_memory))
        codec.cstream
    else
        codec.dstream.ptr = Ptr{CodecZstd.LibZstd.ZSTD_DCtx}(
            LibZstdStatic.ZSTD_createDCtx_advanced(tracked_zstd_memory))
        codec.dstream
    end
    @test native.ptr != C_NULL
    stream = TranscodingStream(codec, IOBuffer(input))
    read(stream, UInt8)
    ptr = native.ptr
    GC.@preserve stream begin
        GC.gc(true)
        @test zstd_live_allocations[] > 0
        @test native.ptr == ptr
        @test read(stream, UInt8) isa UInt8
    end
    if explicitly_close
        close(stream)
        @test zstd_live_allocations[] == 0
    end
    return WeakRef(native), ptr
end

@testset "native context cleanup" begin
    input = rand(UInt8, 1000)
    compressed = transcode(ZstdCompressor, input)
    for (Codec, data) in ((ZstdCompressor, input), (ZstdDecompressor, compressed)),
        explicitly_close in (true, false)
        @test zstd_live_allocations[] == 0
        weak, ptr = tracked_zstd_stream(Codec, data, explicitly_close)
        for _ in 1:3
            GC.gc(true)
        end
        @test weak.value === nothing
        @test zstd_live_allocations[] == 0
        if zstd_live_allocations[] != 0 && weak.value === nothing
            # Release native memory if its owner was collected without freeing it.
            if Codec === ZstdCompressor
                CodecZstd.LibZstd.ZSTD_freeCCtx(ptr)
            else
                CodecZstd.LibZstd.ZSTD_freeDCtx(ptr)
            end
        end
    end
end
