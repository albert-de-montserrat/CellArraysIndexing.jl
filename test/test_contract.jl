@testset "Access contract" for T in (Float32, Float64), B in (0, 1), dims in ((4,), (4,3), (4,3,2))
    @testset "$S" for S in (SVector{3,T}, SMatrix{2,3,T,6})
        A = testarray(S, B, dims)
        I = ntuple(_ -> 1, length(dims))
        K = size(S)
        cell = A[I...]
        @test @inferred(getcell(A, I...)) == cell
        @test @inferred(getcellindex(A, K..., I...)) == cell[K...]
        @test (@cell A[I...]) == cell
        @cell A[I...] = cell + cell
        @test A[I...] == cell + cell
        @index A[K..., I...] = T(7)
        @test (@index A[K..., I...]) == T(7)
        @test getcellindex(A, K..., I...) == T(7)

        # Out-of-axis coordinates which can still flatten to valid storage.
        for d in eachindex(dims), invalid in (0, -1, dims[d] + 1)
            J = Base.setindex(I, invalid, d)
            original = copy(A.data)
            @test_throws BoundsError getcell(A, J...)
            @test_throws BoundsError getcellindex(A, K..., J...)
            @test_throws BoundsError setcell!(A, cell, J...)
            @test_throws BoundsError setcellindex!(A, T(9), K..., J...)
            @test A.data == original
        end
        for d in eachindex(K), invalid in (0, -1, K[d] + 1)
            J = Base.setindex(K, invalid, d)
            @test_throws BoundsError getcellindex(A, J..., I...)
            @test_throws BoundsError setcellindex!(A, T(9), J..., I...)
        end

        # Preserve the existing prefix-copy behavior for oversized RHS arrays.
        rhs = reshape(T.(1:prod(K)), K)
        @test setcell!(A, rhs, I...) === A.data
        @test getcell(A, I...) == S(rhs)
        larger = fill(T(3), (K .+ 1)...)
        setcell!(A, larger, I...)
        @test all(==(T(3)), getcell(A, I...))
        setcell!(A, view(larger, (1:k for k in K)...), I...)
        @test all(==(T(3)), getcell(A, I...))
        small = zeros(T, Base.setindex(K, K[1]-1, 1))
        original = copy(A.data)
        @test_throws BoundsError setcell!(A, small, I...)
        @test A.data == original
        # Source element conversion remains supported by whole-cell setters.
        setcell!(A, ones(Int, K), I...)
        @test all(==(one(T)), getcell(A, I...))
    end
end

# Keep allocation checks behind a function barrier and warm each specialization.
function allocation_check(A, v, I, K)
    getcell(A, I...); setcell!(A, v, I...)
    getcellindex(A, K..., I...); setcellindex!(A, one(eltype(v)), K..., I...)
    return (@allocated(getcell(A, I...)), @allocated(setcell!(A, v, I...)),
            @allocated(getcellindex(A, K..., I...)),
            @allocated(setcellindex!(A, one(eltype(v)), K..., I...)))
end

@testset "Small static access allocations" for B in (0,1), S in (SVector{3,Float64}, SMatrix{2,3,Float64,6})
    A = testarray(S, B, (4,3))
    v = A[1,1]
    allocation_check(A, v, (1,1), size(S))
    @test allocation_check(A, v, (1,1), size(S)) == (0,0,0,0)
end

@testset "Matrix source traversal and prefix copy" for B in (0,1)
    S = SMatrix{2,3,Float64,6}
    A = testarray(S, B, (4,3))
    reference = testarray(S, B, (4,3))
    # An overlapping transposed view makes read/write order observable.
    v = transpose(reshape(view(A.data, 1, :, 1), 3, 2))
    refv = transpose(reshape(view(reference.data, 1, :, 1), 3, 2))
    for i in 1:2, j in 1:3
        reference.data[1, i + (j-1)*2, 1] = refv[i,j]
    end
    setcell!(A, v, 1, 1)
    @test A.data == reference.data

    larger = SMatrix{3,4}(Tuple(Float64.(1:12)))
    setcell!(A, larger, 1, 1)
    @test getcell(A, 1, 1) == larger[1:2,1:3]
end

@testset "B=0 with strided backing storage" for S in (SVector{3,Float64}, SMatrix{2,3,Float64,6})
    storage = zeros(24, length(S), 1)
    A = CellArray{S,2,0}(view(storage, 1:2:24, :, :), (4,3))
    v = S(ntuple(Float64, length(S)))
    setcell!(A, v, 3, 2)
    @test getcell(A, 3, 2) == v
    @test getcellindex(A, size(S)..., 3, 2) == last(v)
    @test all(iszero, view(storage, 2:2:24, :, :))
    @test_throws BoundsError getcell(A, 5, 1)
end
