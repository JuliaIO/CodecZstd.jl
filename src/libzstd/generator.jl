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
            node.exprs[1].args[1] = :(const ZSTD_WINDOWLOG_MAX = sizeof(Csize_t) == 4 ? ZSTD_WINDOWLOG_MAX_32 : ZSTD_WINDOWLOG_MAX_64)
        elseif node.id == :ZSTD_CHAINLOG_MAX
            node.exprs[1].args[1] = :(const ZSTD_CHAINLOG_MAX = sizeof(Csize_t) == 4 ? ZSTD_CHAINLOG_MAX_32 : ZSTD_CHAINLOG_MAX_64)
        elseif node.id == :ZSTD_LIB_VERSION
            node.exprs[1].args[1] = :(const ZSTD_LIB_VERSION = VersionNumber(ZSTD_VERSION_MAJOR, ZSTD_VERSION_MINOR, ZSTD_VERSION_RELEASE))
        elseif node isa ExprNode{Generators.MacroUnsupported}
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