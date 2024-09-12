@eval begin
    # `getcell` generators
    Base.@propagate_inbounds @inline function getcell(A::$DevCellArray{SVector{N, T}, nDim, 0, T}, I::Vararg{Int, nDim}) where {N, nDim, T}
        index = Base._to_linear_index(A,I...)
        SVector{N, T}(A.data[index,i,1] for i in 1:N)
    end

    Base.@propagate_inbounds @inline function getcell(A::$DevCellArray{SMatrix{Ni, Nj, T, N}, nDim, 0, T}, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, nDim}
        index = Base._to_linear_index(A, I...)
        linear_SMatrix = LinearIndices((1:Nj, 1:Nj))
        SMatrix{Ni, Nj, T}(A.data[index, linear_SMatrix[i, j], 1] for i in 1:Ni, j in 1:Nj)
    end

    # `setcell!` generators
    @generated function setcell!(A::$DevCellArray{SVector{N, T}, nDim, 0, T}, v::AbstractVector, I::Vararg{Int, nDim}) where {N, nDim, T}
        quote
            Base.@_inline_meta
            Base.@_propagate_inbounds_meta
            index = Base._to_linear_index(A, I...)
            Base.@nexprs $N i -> setindex!(A.data, v[i], index, i, 1)
        end
    end
    
    @generated function setcell!(A::$DevCellArray{SMatrix{Ni, Nj, T, N}, nDim, 0, T},  v::AbstractMatrix, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, nDim}
        quote
            Base.@_inline_meta
            Base.@_propagate_inbounds_meta
            index = Base._to_linear_index(A, I...)
            linear_SMatrix = LinearIndices((1:$Nj, 1:$Nj))
            Base.@nexprs $Ni i -> 
                Base.@nexprs $Nj j ->
                    setindex!(A.data, v[i,j], index, linear_SMatrix[i, j], 1)
        end
    end

    # `getcellindex` generators
    Base.@propagate_inbounds @inline function getcellindex(A::$DevCellArray{SVector, nDim, 1, T}, cellᵢ::Int, I::Vararg{Int, nDim}) where {nDim, T}
        index = Base._to_linear_index(A,I...)
        A.data[index, cellᵢ, 1]
    end
    
    Base.@propagate_inbounds @inline function getcellindex(A::$DevCellArray{SMatrix{Ni, Nj, T, N}, nDim, 1, T}, cellᵢ::Int, cellⱼ::Int, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, nDim}
        index = Base._to_linear_index(A, I...)
        linear_SMatrix = LinearIndices((1:Nj, 1:Nj))
        A.data[index, linear_SMatrix[cellᵢ, cellⱼ], 1]
    end

    # `setcellindex!` generators
    Base.@propagate_inbounds function setcellindex!(A::$DevCellArray{SVector, nDim, 1, T}, v::T, cellᵢ::Int, I::Vararg{Int, nDim}) where {nDim, T}
        index = Base._to_linear_index(A, I...)
        setindex!(A.data, v, index, cellᵢ, 1)
    end
    
    Base.@propagate_inbounds function setcellindex!(A::$DevCellArray{SMatrix{Ni, Nj, T, N}, nDim, 1, T}, v::T, cellᵢ::Int, cellⱼ::Int, I::Vararg{Int, nDim}) where {N, Ni, Nj, nDim, T}
        index = Base._to_linear_index(A, I...)
        linear_SMatrix = LinearIndices((1:Nj, 1:Nj))
        setindex!(A.data, v, index, linear_SMatrix[cellᵢ, cellⱼ], 1)
    end

end
