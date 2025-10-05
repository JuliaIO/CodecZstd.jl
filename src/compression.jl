# Compressor Codec
# ================

struct ZstdCompressor <: TranscodingStreams.Codec
    cstream::CStream
    level::Int
    windowLog::Int32
    endOp::LibZstd.ZSTD_EndDirective
end

function Base.show(io::IO, codec::ZstdCompressor)
    if codec.endOp == LibZstd.ZSTD_e_end
        print(io, "ZstdFrameCompressor(level=$(codec.level))")
    else
        print(io, summary(codec), "(")
        print(io, "level=$(codec.level)")
        if codec.windowLog != Int32(0)
            print(io, ", windowLog=Int32($(codec.windowLog))")
        end
        print(io, ")")
    end
end

# Same as the zstd command line tool (v1.2.0).
const DEFAULT_COMPRESSION_LEVEL = 3

# This is technically part of the static api, but I don't see how this could be changed easily.
const ZSTD_WINDOWLOG_LIMIT_DEFAULT = Int32(27)

"""
    level_bounds() -> min::Int32, max::Int32

Return the minimum and maximum compression levels available.
"""
function level_bounds()
    bounds = LibZstd.ZSTD_cParam_getBounds(LibZstd.ZSTD_c_compressionLevel)
    @assert !iserror(bounds.error)
    Int32(bounds.lowerBound), Int32(bounds.upperBound)
end

"""
    windowLog_bounds() -> min::Int32, max::Int32

Return the minimum and maximum windowLog available.
"""
function windowLog_bounds()
    bounds = LibZstd.ZSTD_cParam_getBounds(LibZstd.ZSTD_c_windowLog)
    @assert !iserror(bounds.error)
    Int32(bounds.lowerBound), Int32(bounds.upperBound)
end

"""
    ZstdCompressor(;level=$(DEFAULT_COMPRESSION_LEVEL))

Create a new zstd compression codec.

Arguments
---------
- `level`: compression level, regular levels are 1-22.

  Levels ≥ 20 should be used with caution, as they require more memory.
  The library also offers negative compression levels,
  which extend the range of speed vs. ratio preferences.
  The lower the level, the faster the speed (at the cost of compression).
  0 is a special value for the default level of the c library.
  The level will be clamped by `level_bounds()`.

Advanced compression parameters.

- `windowLog::Int32= Int32(0)`: Maximum allowed back-reference distance, expressed as power of 2.

  This will set a memory budget for streaming decompression,
  with larger values requiring more memory
  and typically compressing more.
  Must be clamped between `windowLog_bounds()[1]` and `windowLog_bounds()[2]` inclusive.
  Special: value 0 means "use default windowLog".
  Note: Using a windowLog greater than $(ZSTD_WINDOWLOG_LIMIT_DEFAULT)
  requires explicitly allowing such size at streaming decompression stage.
"""
function ZstdCompressor(;
        level::Integer=DEFAULT_COMPRESSION_LEVEL,
        windowLog::Int32=Int32(0),
    )
    windowLog_range = (:)(windowLog_bounds()...)
    if !iszero(windowLog) && windowLog ∉ windowLog_range
        # Since this has to be matched on the decompression side, throw instead of clamping.
        throw(ArgumentError("windowLog ∈ $(windowLog_range) must hold. Got\nwindowLog => $(windowLog)"))
    end
    ZstdCompressor(
        CStream(),
        clamp(level, level_bounds()...),
        windowLog,
        LibZstd.ZSTD_e_continue,
    )
end
ZstdCompressor(cstream, level) = ZstdCompressor(cstream, level, Int32(0), :continue)

"""
   ZstdFrameCompressor(;level=$(DEFAULT_COMPRESSION_LEVEL))

Create a new zstd compression codec that reads the available input and then
closes the frame, encoding the decompressed size of that frame.

Arguments
---------
- `level`: compression level, regular levels are 1-22.

  Levels ≥ 20 should be used with caution, as they require more memory.
  The library also offers negative compression levels,
  which extend the range of speed vs. ratio preferences.
  The lower the level, the faster the speed (at the cost of compression).
  0 is a special value for `ZSTD_defaultCLevel()`.
  The level will be clamped by `level_bounds()`.
"""
function ZstdFrameCompressor(;level::Integer=DEFAULT_COMPRESSION_LEVEL)
    ZstdCompressor(
        CStream(),
        clamp(level, level_bounds()...),
        Int32(0),
        LibZstd.ZSTD_e_end,
    )
end
# pretend that ZstdFrameCompressor is a compressor type
function TranscodingStreams.transcode(C::typeof(ZstdFrameCompressor), args...)
    codec = C()
    initialize(codec)
    try
        return transcode(codec, args...)
    finally
        finalize(codec)
    end
end

const ZstdCompressorStream{S} = TranscodingStream{ZstdCompressor,S} where S<:IO

"""
    ZstdCompressorStream(stream::IO; kwargs...)

Create a new zstd compression stream (see `ZstdCompressor` for `kwargs`).
"""
function ZstdCompressorStream(stream::IO; kwargs...)
    x, y = splitkwargs(kwargs, (:level, :windowLog))
    return TranscodingStream(ZstdCompressor(;x...), stream; y...)
end


# Methods
# -------

function TranscodingStreams.finalize(codec::ZstdCompressor)
    if codec.cstream.ptr != C_NULL
        # This should never fail
        ret = free!(codec.cstream)
        @assert !iserror(ret)
        codec.cstream.ptr = C_NULL
    end
    return
end

function TranscodingStreams.startproc(codec::ZstdCompressor, mode::Symbol, err::Error)
    if codec.cstream.ptr == C_NULL
        # Create the context following the example in:
        # https://github.com/facebook/zstd/blob/98d2b90e82e5188968368d952ad6b371772e78e5/examples/streaming_compression.c#L36-L44
        codec.cstream.ptr = LibZstd.ZSTD_createCCtx()
        if codec.cstream.ptr == C_NULL
            throw(OutOfMemoryError())
        end
        ret = LibZstd.ZSTD_CCtx_setParameter(codec.cstream, LibZstd.ZSTD_c_compressionLevel, clamp(codec.level, Cint))
        if iserror(ret)
            # This is unreachable according to zstd.h
            err[] = ErrorException("zstd error setting compressionLevel")
            return :error
        end
        if !iszero(codec.windowLog)
            ret = LibZstd.ZSTD_CCtx_setParameter(codec.cstream, LibZstd.ZSTD_c_windowLog, Cint(codec.windowLog))
            if iserror(ret)
                # This should be unreachable because windowLog is checked in the constructor.
                err[] = ErrorException("zstd error setting windowLog to $(codec.windowLog)")
                return :error
            end
        end
        # TODO Allow setting other parameters here.
    end
    code = reset!(codec.cstream, 0 #=unknown source size=#)
    if iserror(code)
        # This is unreachable according to zstd.h
        err[] = ErrorException("zstd error resetting context.")
        return :error
    end
    return :ok
end

function TranscodingStreams.process(codec::ZstdCompressor, input::Memory, output::Memory, err::Error)
    if codec.cstream.ptr == C_NULL
        error("startproc must be called before process")
    end
    cstream = codec.cstream
    ibuffer_starting_pos = UInt(0)
    if codec.endOp == LibZstd.ZSTD_e_end &&
       cstream.ibuffer.size != cstream.ibuffer.pos
            # While saving a frame, the prior process run did not finish writing the frame.
            # A positive code indicates the need for additional output buffer space.
            # Re-run with the same cstream.ibuffer.size as pledged for the frame,
            # otherwise a "Src size is incorrect" error will occur.

            # For the current frame, cstream.ibuffer.size - cstream.ibuffer.pos
            # must reflect the remaining data. Thus neither size or pos can change.
            # Store the starting pos since it will be non-zero.
            ibuffer_starting_pos = cstream.ibuffer.pos

            # Set the pointer relative to input.ptr such that
            # cstream.ibuffer.src + cstream.ibuffer.pos == input.ptr
            cstream.ibuffer.src = input.ptr - cstream.ibuffer.pos
    else
        cstream.ibuffer.src = input.ptr
        cstream.ibuffer.size = input.size
        cstream.ibuffer.pos = 0
    end
    cstream.obuffer.dst = output.ptr
    cstream.obuffer.size = output.size
    cstream.obuffer.pos = 0
    if input.size == 0
        code = compress!(cstream; endOp = LibZstd.ZSTD_e_end)
    else
        code = compress!(cstream; endOp = codec.endOp)
    end
    Δin = Int(cstream.ibuffer.pos - ibuffer_starting_pos)
    Δout = Int(cstream.obuffer.pos)
    if iserror(code)
        if error_code(code) == Integer(LibZstd.ZSTD_error_memory_allocation)
            throw(OutOfMemoryError())
        end
        err[] = ErrorException("zstd compression error: " * error_name(code))
        return Δin, Δout, :error
    else
        return Δin, Δout, input.size == 0 && code == 0 ? :end : :ok
    end
end
