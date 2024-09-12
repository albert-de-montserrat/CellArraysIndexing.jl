@testset "Read and write cells indices" begin
    @testset "2D" begin
        ni = 4, 4

        @testset "SVector" begin
            A = @rand(ni..., celldims=(2,));
            setcellindex!(A, 1.2, 2, 1, 1)
            @test getcellindex(A, 2, 1, 1) == 1.2
            
            @index A[2, 1, 1] = 5.1
            @test 5.1 == @index A[2, 1, 1]           
        end

        @testset "SMatrix" begin
            A = @rand(ni..., celldims=(2,2));
            setcellindex!(A, 1.2, 2, 2, 1, 1)
            @test getcellindex(A, 2, 2, 1, 1) == 1.2
            
            @index A[2, 2, 1, 1] = 5.1
            @test 5.1 == @index A[2, 2, 1, 1] 
        end
    end

    @testset "3D" begin
        ni = 4, 4, 4

        @testset "SVector" begin
            A = @rand(ni..., celldims=(2,));
            setcellindex!(A, 1.2, 2, 1, 1, 1)
            @test getcellindex(A, 2, 1, 1, 1) == 1.2
            
            @index A[2, 1, 1, 1] = 5.1
            @test 5.1 == @index A[2, 1, 1, 1] 
        end

        @testset "SMatrix" begin
            A = @rand(ni..., celldims=(2,2));
            setcellindex!(A, 1.2, 2, 2, 1, 1, 1)
            @test getcellindex(A, 2, 2, 1, 1, 1) == 1.2
            
            @index A[2, 2, 1, 1, 1] = 5.1
            @test 5.1 == @index A[2, 2, 1, 1, 1] 
        end
    end
end