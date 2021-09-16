using Clang
using Zstd_jll

const LIBZSTD_INCLUDE = joinpath(dirname(Zstd_jll.libzstd_path), "..", "include")
const LIBZSTD_HEADERS = [joinpath(LIBZSTD_INCLUDE, header) for header in readdir(LIBZSTD_INCLUDE) if endswith(header, ".h")]

wc = init(; headers = LIBZSTD_HEADERS,
            output_file = joinpath(@__DIR__, "libzstd_api.jl"),
            common_file = joinpath(@__DIR__, "libzstd_common.jl"),
            clang_includes = vcat(LIBZSTD_INCLUDE, CLANG_INCLUDE),
            clang_args = ["-I", joinpath(LIBZSTD_INCLUDE, "..")],
            header_wrapped = (root, current)->root == current,
            header_library = x->"libzstd",
            clang_diagnostics = true,
         )

run(wc)

# Clang.jl 14.0
#=
using Clang.Generators
using Zstd_jll

cd(@__DIR)

include_dir = joinpath(Zstd_jll.artifact_dir, "include") |> normpath
options = load_options(joinpath(@__DIR__, "generator.toml"))

args = get_default_args()
push!(args, "-I$include_dir")

headers = [joinpath(include_dir, header) for header in readdir(include_dir) if endswith(header, ".h")]

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)
=#