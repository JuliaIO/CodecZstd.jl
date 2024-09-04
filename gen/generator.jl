# generator.jl
# generator.jl uses Clang to parse zdict.h, zstd.h, zstd_errors.h and generates LibZstd.jl

# Clang.jl 0.14 (40e3b903)
# As of 2021-09-18 0.14 is currently unreleased
# See https://github.com/JuliaInterop/Clang.jl/milestone/1

# Configuration files:
# generator.toml is used to configure the Clang generator
# prologue.jl adds some definitions to beginning LibZstd.jl

# Directions:
# 1. Change to this directory e.g. `import CodecZstd; cd(joinpath(dirname(pathof(CodecZstd)), "libzstd"))`
# 2. Activate the project in this directory e.g. `using Pkg; Pkg.activate(".")`
# 2a. You may need to dev Clang to get 0.14 or greater: `Pkg.dev("Clang")`
# 3. Include this file: `include("generator.jl")``
# Alternatively, from the shell, `cd libzstd; julia --project=. generator.jl`

#=
# Example Code Block to Run Generator
import CodecZstd; cd(joinpath(dirname(pathof(CodecZstd)), "libzstd"))
using Pkg; Pkg.activate(".")
# Pkg.dev("Clang")
include("generator.jl")
=#

using Clang.Generators
using Zstd_jll


if !@isdefined(ZSTD_STATIC_LINKING_ONLY)
    const ZSTD_STATIC_LINKING_ONLY = false
end

cd(@__DIR__)

include_dir = joinpath(Zstd_jll.artifact_dir, "include") |> normpath
options = load_options(joinpath(@__DIR__, "generator.toml"))
if ZSTD_STATIC_LINKING_ONLY
    @warn "Static linking only functions will be included"
    options["general"]["output_file_path"] = "../test/LibZstd_clang_static.jl"
    options["general"]["module_name"] = "LibZstdStatic"
end

args = get_default_args()
push!(args, "-I$include_dir")
if ZSTD_STATIC_LINKING_ONLY
    push!(args, "-DZSTD_STATIC_LINKING_ONLY")
end

headers = [joinpath(include_dir, header) for header in readdir(include_dir) if endswith(header, ".h")]

# create context
ctx = create_context(headers, args, options)

# build without printing so we can do custom rewriting
build!(ctx, BUILDSTAGE_NO_PRINTING)

# custom rewriter
function rewrite!(e::Expr)
    if e.head == :struct && length(e.args) > 1 && (e.args[2] == :ZSTD_inBuffer_s || e.args[2] == :ZSTD_outBuffer_s)
        # Make Zstd_inBuffer and Zstd_outBuffer mutable
        e.args[1] = true
    end
    e
end

function rewrite!(dag::ExprDAG)
    for node in get_nodes(dag)
        if node.id == :ZSTD_WINDOWLOG_MAX
            # Unsupported macro
            node.exprs[1].args[1] = :(const ZSTD_WINDOWLOG_MAX = sizeof(Csize_t) == 4 ? ZSTD_WINDOWLOG_MAX_32 : ZSTD_WINDOWLOG_MAX_64)
        elseif node.id == :ZSTD_CHAINLOG_MAX
            # Unsupported macro
            node.exprs[1].args[1] = :(const ZSTD_CHAINLOG_MAX = sizeof(Csize_t) == 4 ? ZSTD_CHAINLOG_MAX_32 : ZSTD_CHAINLOG_MAX_64)
        elseif node.id == :ZSTD_LIB_VERSION
            # Unsupported macro
            node.exprs[1].args[1] = :(const ZSTD_LIB_VERSION = VersionNumber(ZSTD_VERSION_MAJOR, ZSTD_VERSION_MINOR, ZSTD_VERSION_RELEASE))
        elseif node isa ExprNode{Generators.MacroUnsupported}
            # Usually just export symbols for ZSTDLIB_API, ZDICTLIB_API, ZSTDERRORLIB_API
            node.exprs[1].args[1] = :(const $(node.id) = nothing)
        end
        for expr in get_exprs(node)
            rewrite!(expr)
        end
    end
end

rewrite!(ctx.dag)

# print
build!(ctx, BUILDSTAGE_PRINTING_ONLY)
