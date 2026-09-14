@testset "Layout B=$B" for B in (0, 1)
@testset "Read and write cells" begin
    @testset "2D" begin
        ni = 4, 4

        @testset "SVector" begin
            A = testarray(SVector{2,Float64}, B, ni)
            c = A[2,2]
            setcell!(A, c, 1, 1)

            @test A[1,1] == A[2,2]
            @test A[1,1] == getcell(A,2,2)
        end

        @testset "SMatrix" begin
            # rectangular matrix
            A = testarray(SMatrix{2,2,Float64,4}, B, ni)
            c = A[2,2]
            setcell!(A, c, 1, 1)

            @test A[1,1] == A[2,2]
            @test A[1,1] == getcell(A,2,2)

            # non-rectangular matrix
            A = testarray(SMatrix{6,3,Float64,18}, B, ni)
            c = A[2,2]
            setcell!(A, c, 1, 1)

            @test A[1,1] == A[2,2]
            @test A[1,1] == getcell(A,2,2)
        end
    end

    @testset "3D" begin
        ni = 4, 4, 4

        @testset "SVector" begin
            A = testarray(SVector{2,Float64}, B, ni)
            c = A[2,2,2]
            setcell!(A, c, 1, 1, 1)

            @test A[1,1,1] == A[2,2,2]
            @test A[1,1,1] == getcell(A,2,2,2)
        end

        @testset "SMatrix" begin
            A = testarray(SMatrix{2,2,Float64,4}, B, ni)
            c = A[2,2,2]
            setcell!(A, c, 1, 1, 1)

            @test A[1,1,1] == A[2,2,2]
            @test A[1,1,1] == getcell(A,2,2,2)

            A = testarray(SMatrix{6,3,Float64,18}, B, ni)
            c = A[2,2,2]
            setcell!(A, c, 1, 1, 1)

            @test A[1,1,1] == A[2,2,2]
            @test A[1,1,1] == getcell(A,2,2,2)
        end
    end
end

end
