using CellArraysIndexing, Test
using ParallelStencil
@init_parallel_stencil(Threads, Float64, 2)

push!(LOAD_PATH, "..")

istest(f) = endswith(f, ".jl") && startswith(basename(f), "test_")

function runtests()
    testdir = pwd()
    testfiles = sort(
        filter(
            istest,
            vcat([joinpath.(root, files) for (root, dirs, files) in walkdir(testdir)]...),
        ),
    )

     for f in testfiles
        include(f)
    end
end

runtests()