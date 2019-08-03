using BinaryProvider

const verbose = "--verbose" in ARGS
const prefix = Prefix(get(filter(!isequal("--verbose"), ARGS), 1, joinpath(@__DIR__, "usr")))
products = [LibraryProduct(prefix, ["libzstd"], :libzstd)]

bin_prefix = "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Zstd-v1.4.2+0"

download_info = Dict(
    Linux(:aarch64, libc=:glibc) =>
        ("$bin_prefix/Zstd.v1.4.2.aarch64-linux-gnu.tar.gz",
         "fa5b1a0bbaf0d0c9b68b74f985609c16212288ad1822834a8bc973dc28de7b3b"),
    Linux(:aarch64, libc=:musl) =>
        ("$bin_prefix/Zstd.v1.4.2.aarch64-linux-musl.tar.gz",
         "913f994d6c6005d2b574a1f7b00cef59fc0ad99ac1b6df91ac16ea0b7fee7f99"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf) =>
        ("$bin_prefix/Zstd.v1.4.2.arm-linux-gnueabihf.tar.gz",
         "bf474a692e013b0c6e74b9a738e04c6aa12b0c0f54269a6d94eed45eec05aabb"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf) =>
        ("$bin_prefix/Zstd.v1.4.2.arm-linux-musleabihf.tar.gz",
         "489e8706c27b6277b3cd604f9bfc88c8f81d2ae9b76d34062f099fe31c024e5d"),
    Linux(:i686, libc=:glibc) =>
        ("$bin_prefix/Zstd.v1.4.2.i686-linux-gnu.tar.gz",
         "ed8652f9509fd6cb6cd3cca9023326b698d1437f6d22026c7763a32658a8fca5"),
    Linux(:i686, libc=:musl) =>
        ("$bin_prefix/Zstd.v1.4.2.i686-linux-musl.tar.gz",
         "b0de4b032efa9a0108c32a00e27367352e36304f3f62c3cfbe9cdae5ff48fa2f"),
    Windows(:i686) =>
        ("$bin_prefix/Zstd.v1.4.2.i686-w64-mingw32.tar.gz",
         "785a2a97ba59fbe2529b4ded1e380d1385351b805f9d0b91df64802db36648d5"),
    Linux(:powerpc64le, libc=:glibc) =>
        ("$bin_prefix/Zstd.v1.4.2.powerpc64le-linux-gnu.tar.gz",
         "8dbc6e14931d70f5b112f9f00534c80d2b5cde18dbb74ebae31b6ff97f7863dd"),
    MacOS(:x86_64) =>
        ("$bin_prefix/Zstd.v1.4.2.x86_64-apple-darwin14.tar.gz",
         "5ff8c2b4719fd1b605413388608007e5bdeb92caa60619c32f1809dc6907fcfc"),
    Linux(:x86_64, libc=:glibc) =>
        ("$bin_prefix/Zstd.v1.4.2.x86_64-linux-gnu.tar.gz",
         "a6806ca68680bf813ff326f65f4a478574a2a4e27b8ad72c8e9a8f180a89b816"),
    Linux(:x86_64, libc=:musl) =>
        ("$bin_prefix/Zstd.v1.4.2.x86_64-linux-musl.tar.gz",
         "b00c751cfb61d160415c427a795fdc3521735c37c3c32164b8218f210e8a3d51"),
    FreeBSD(:x86_64) =>
        ("$bin_prefix/Zstd.v1.4.2.x86_64-unknown-freebsd11.1.tar.gz",
         "d38e10e988a4b7229906c1f52f1b1a12589063d1d6ad90315fbc72532650f468"),
    Windows(:x86_64) =>
        ("$bin_prefix/Zstd.v1.4.2.x86_64-w64-mingw32.tar.gz",
         "ab42350bf99389cd9118e1d10a310d6a572afcfe521e70abd42f7bfa340666bd"),
)

unsatisfied = any(p->!satisfied(p, verbose=verbose), products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    error("Your platform (\"$(Sys.MACHINE)\", parsed as ",
          "\"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

if unsatisfied || !isinstalled(dl_info..., prefix=prefix)
    install(dl_info..., prefix=prefix, force=true, verbose=verbose)
end

write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
