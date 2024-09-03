using Test
using CodecZstd: ZstdError

@static if VERSION ≥ v"1.8"
@testset "ZSTD Errors" begin
    @test_throws "ZstdError: No error detected" throw(ZstdError(0))
    @test_throws "ZstdError: Error (generic)" throw(ZstdError(18446744073709551615))
    @test_throws "ZstdError: Unknown frame descriptor" throw(ZstdError(18446744073709551606))
    @test_throws "ZstdError: Version not supported" throw(ZstdError(18446744073709551604))
    @test_throws "ZstdError: Unsupported frame parameter" throw(ZstdError(18446744073709551602))
    @test_throws "ZstdError: Frame requires too much memory for decoding" throw(ZstdError(18446744073709551600))
    @test_throws "ZstdError: Data corruption detected" throw(ZstdError(18446744073709551596))
    @test_throws "ZstdError: Restored data doesn't match checksum" throw(ZstdError(18446744073709551594))
    @test_throws "ZstdError: Header of Literals' block doesn't respect format specification" throw(ZstdError(18446744073709551592))
    @test_throws "ZstdError: Dictionary is corrupted" throw(ZstdError(18446744073709551586))
    @test_throws "ZstdError: Dictionary mismatch" throw(ZstdError(18446744073709551584))
    @test_throws "ZstdError: Cannot create Dictionary from provided samples" throw(ZstdError(18446744073709551582))
    @test_throws "ZstdError: Unsupported parameter" throw(ZstdError(18446744073709551576))
    @test_throws "ZstdError: Unsupported combination of parameters" throw(ZstdError(18446744073709551575))
    @test_throws "ZstdError: Parameter is out of bound" throw(ZstdError(18446744073709551574))
    @test_throws "ZstdError: tableLog requires too much memory : unsupported" throw(ZstdError(18446744073709551572))
    @test_throws "ZstdError: Unsupported max Symbol Value : too large" throw(ZstdError(18446744073709551570))
    @test_throws "ZstdError: Specified maxSymbolValue is too small" throw(ZstdError(18446744073709551568))
    @test_throws "ZstdError: pledged buffer stability condition is not respected" throw(ZstdError(18446744073709551566))
    @test_throws "ZstdError: Operation not authorized at current processing stage" throw(ZstdError(18446744073709551556))
    @test_throws "ZstdError: Context should be init first" throw(ZstdError(18446744073709551554))
    @test_throws "ZstdError: Allocation error : not enough memory" throw(ZstdError(18446744073709551552))
    @test_throws "ZstdError: workSpace buffer is not large enough" throw(ZstdError(18446744073709551550))
    @test_throws "ZstdError: Destination buffer is too small" throw(ZstdError(18446744073709551546))
    @test_throws "ZstdError: Src size is incorrect" throw(ZstdError(18446744073709551544))
    @test_throws "ZstdError: Operation on NULL destination buffer" throw(ZstdError(18446744073709551542))
    @test_throws "ZstdError: Operation made no progress over multiple calls, due to output buffer being full" throw(ZstdError(18446744073709551536))
    @test_throws "ZstdError: Operation made no progress over multiple calls, due to input being empty" throw(ZstdError(18446744073709551534))
end
end

# Use the following function to print the tests above
function print_error_tests()
    err_codes = [0, 1, 10, 12, 14, 16, 20, 22, 24, 30, 32, 34, 40, 41, 42, 44, 46, 48, 50, 60, 62, 64, 66, 70, 72, 74, 80, 82];
    println("@testset \"ZSTD Errors\" begin")
    for err_code in err_codes
        code = typemax(Csize_t)-err_code+1
        println("    @test_throws \"" * string(CodecZstd.ZstdError(typemax(Csize_t) - err_code + 1)) * "\" throw(ZstdError($code))")
    end
    println("end")
end

