@testset "Read and write cells" begin
    @testset "2D" begin
        ni = 4, 4

        @testset "SVector" begin
            A = @rand(ni..., celldims=(2,))
            c = A[2,2]
            setcell!(A, c, 1, 1)

            @test A[1,1] == A[2,2]
            @test A[1,1] == getcell(A,2,2)
        end

        @testset "SMatrix" begin
            A = @rand(ni..., celldims=(2,2))
            c = A[2,2]
            setcell!(A, c, 1, 1)

            @test A[1,1] == A[2,2]
            @test A[1,1] == getcell(A,2,2)
        end
    end

    @testset "3D" begin
        ni = 4, 4, 4

        @testset "SVector" begin
            A = @rand(ni..., celldims=(2,))
            c = A[2,2,2]
            setcell!(A, c, 1, 1, 1)

            @test A[1,1,1] == A[2,2,2]
            @test A[1,1,1] == getcell(A,2,2,2)
        end

        @testset "SMatrix" begin
            A = @rand(ni..., celldims=(2,2))
            c = A[2,2,2]
            setcell!(A, c, 1, 1, 1)

            @test A[1,1,1] == A[2,2,2]
            @test A[1,1,1] == getcell(A,2,2,2)
        end
    end
end
