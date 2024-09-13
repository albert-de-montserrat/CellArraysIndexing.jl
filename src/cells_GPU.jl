
# `getcell` generators
Base.@propagate_inbounds @inline function getcell(A::CellArray{SVector{N, T}, nDim, 0, TA}, I::Vararg{Int, nDim}) where {N, nDim, T, TA}
    index = Base._to_linear_index(A,I...)
    SVector{N, T}(A.data[index,i,1] for i in 1:N)
end

Base.@propagate_inbounds @inline function getcell(A::CellArray{SMatrix{Ni, Nj, T, N}, nDim, 0, TA}, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, TA, nDim}
    index = Base._to_linear_index(A, I...)
    linear_SMatrix = LinearIndices((1:Nj, 1:Nj))
    SMatrix{Ni, Nj, T}(A.data[index, linear_SMatrix[i, j], 1] for i in 1:Ni, j in 1:Nj)
end

# `setcell!` generators
@generated function setcell!(A::CellArray{SVector{N, T}, nDim, 0, TA}, v::AbstractVector, I::Vararg{Int, nDim}) where {N, nDim, T, TA}
    quote
        Base.@_inline_meta
        Base.@_propagate_inbounds_meta
        index = Base._to_linear_index(A, I...)
        Base.@nexprs $N i -> setindex!(A.data, v[i], index, i, 1)
    end
end

@generated function setcell!(A::CellArray{SMatrix{Ni, Nj, T, N}, nDim, 0, TA},  v::AbstractMatrix, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, TA, nDim}
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
