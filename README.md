# CellArraysIndexing.jl

This package provides faster read and writes to `CellArray` objects from [CellArrays.jl](https://github.com/omlins/CellArrays.jl) using the macros `@cell` and `@index`.

## Benchmarks
```julia
using CellArraysIndexing, ParallelStencil, StaticArrays
using Chairmarks
@init_parallel_stencil(Threads, Float64, 2)
ni = 4, 4
A = @rand(ni..., celldims=(2,));
B = @rand(ni..., celldims=(2,2));
```

Access the 2nd element of the `Cellarray[1,1]`
```julia-repl
julia> @be @index $A[2, 1, 1] # CellArraysIndexing.jl
Benchmark: 5137 samples with 7287 evaluations
min    2.270 ns
median 2.384 ns
mean   2.525 ns
max    13.580 ns

julia> @be $A[1, 1][2]
Benchmark: 4655 samples with 2718 evaluations
min    3.418 ns
median 6.929 ns
mean   7.464 ns
max    21.799 ns
```

Mutate the 2nd element of the `Cellarray[1,1]`
```julia-repl
julia> @be @index $A[2, 1, 1] = 9.4 # CellArraysIndexing.jl
Benchmark: 4373 samples with 7476 evaluations
min    2.274 ns
median 2.380 ns
mean   2.483 ns
max    15.254 ns
```

Mutate the whole `Cellarray[1,1]`
```julia-repl
julia> v = @SVector rand(2);

julia> @be @cell $A[1, 1] = $v # CellArraysIndexing.jl
Benchmark: 5000 samples with 7611 evaluations
min    2.272 ns
median 2.360 ns
mean   2.461 ns
max    10.818 ns

julia> @be $A[1, 1] = $v # CellArrays.jl
Benchmark: 4150 samples with 6002 evaluations
min    3.423 ns
median 3.749 ns
mean   3.841 ns
max    18.327 ns
```

Access the [2,2] element of the `Cellarray[1,1]`
```julia-repl
julia> @be @index $B[2, 2, 1, 1] # CellArraysIndexing.jl
Benchmark: 5172 samples with 7118 evaluations
min    2.271 ns
median 2.383 ns
mean   2.540 ns
max    13.879 ns

julia> @be $B[1, 1][2, 2] # CellArrays.jl
Benchmark: 4552 samples with 4981 evaluations
min    3.689 ns
median 3.907 ns
mean   4.079 ns
max    9.921 ns
```

Mutate the 2nd element of the `Cellarray[1,1]`
```julia-repl
julia> @be @index $B[2, 2, 1, 1] = 9.4 # CellArraysIndexing.jl
Benchmark: 4965 samples with 7619 evaluations
min    2.275 ns
median 2.384 ns
mean   2.497 ns
max    13.021 ns
```

Mutate the whole `Cellarray[1,1]`
```julia-repl
julia> v = @SMatrix rand(2,2);

julia> @be @cell $B[1, 1] = $v # CellArraysIndexing.jl
Benchmark: 4680 samples with 6641 evaluations
min    2.842 ns
median 2.936 ns
mean   3.057 ns
max    14.788 ns

julia> @be $B[1, 1] = $v # CellArrays.jl
Benchmark: 4066 samples with 4655 evaluations
min    4.627 ns
median 4.995 ns
mean   5.049 ns
max    24.535 ns
```