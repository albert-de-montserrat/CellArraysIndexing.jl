using CellArraysIndexing, CellArrays, StaticArrays, Test

function testarray(::Type{S}, B, dims) where S
    A = CPUCellArray{S,B}(undef, dims)
    for i in eachindex(A.data)
        A.data[i] = mod(i, 97) / 97
    end
    return A
end

istest(f) = endswith(f, ".jl") && startswith(basename(f), "test_")

function runtests()
    testdir = @__DIR__
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
