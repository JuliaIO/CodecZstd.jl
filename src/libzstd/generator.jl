# Clang.jl 14.0
using Clang.Generators
using Zstd_jll


cd(@__DIR__)

include_dir = joinpath(Zstd_jll.artifact_dir, "include") |> normpath
options = load_options(joinpath(@__DIR__, "generator.toml"))

args = get_default_args()
push!(args, "-I$include_dir")
push!(args, "-DZSTD_STATIC_LINKING_ONLY")

headers = [joinpath(include_dir, header) for header in readdir(include_dir) if endswith(header, ".h")]

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)
run(`git apply libzstd_clang_generated.patch`)