# CodecZstd.jl benchmarks

This directory contains benchmarks for CodecZstd. To run all the
benchmarks, launch `julia --project=benchmark` and enter:

``` julia
using PkgBenchmark
import CodecZstd

benchmarkpkg(CodecZstd)
```