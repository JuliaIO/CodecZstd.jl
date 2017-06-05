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

@BinDeps.install Dict(:libzstd=>:libzstd)
