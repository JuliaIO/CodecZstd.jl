module CodecZstd

export
    ZstdInflation,
    ZstdInflationStream,
    ZstdDeflation,
    ZstdDeflationStream

import TranscodingStreams:
    TranscodingStreams,
    Codec,
    Read,
    Write,
    ProcCode,
    PROC_OK,
    PROC_FINISH,
    TranscodingStream,
    process,
    finish

include("lowlevel.jl")
include("state.jl")
include("inflation.jl")
include("deflation.jl")

end # module
