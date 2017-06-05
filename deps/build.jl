using BinDeps

BinDeps.@setup

libzstd = library_dependency("libzstd")

provides(AptGet, Dict("zstd"=>libzstd))

if is_apple()
    if Pkg.installed("Homebrew") === nothing
        Pkg.add("Homebrew")
    end
    import Homebrew
    provides(Homebrew.HB, "zstd", libzstd, os=:Darwin)
end

# FIXME: temporal hack to make CI happy; dependencies should be declared in REQUIRE.
if Pkg.installed("TranscodingStreams") === nothing
    Pkg.clone("https://github.com/bicycle1885/TranscodingStreams.jl")
end

@BinDeps.install Dict(:libzstd=>:libzstd)
