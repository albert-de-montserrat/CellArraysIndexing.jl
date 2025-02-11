# `getcellindex` generators
Base.@propagate_inbounds @inline function getcellindex(A::CellArray{SVector{N, T}, nDim, 0, TA}, cellᵢ::Int, I::Vararg{Int, nDim}) where {nDim, N, T, TA}
    index = Base._to_linear_index(A,I...)
    A.data[index, cellᵢ, 1]
end

Base.@propagate_inbounds @inline function getcellindex(A::CellArray{SMatrix{Ni, Nj, T, N}, nDim, 0, TA}, cellᵢ::Int, cellⱼ::Int, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, TA, nDim}
    index = Base._to_linear_index(A, I...)
    linear_SMatrix = LinearIndices((1:Ni, 1:Nj))
    A.data[index, linear_SMatrix[cellᵢ, cellⱼ], 1]
end

# `setcellindex!` generators
Base.@propagate_inbounds function setcellindex!(A::CellArray{SVector{N, T}, nDim, 0, TA}, v::Real, cellᵢ::Int, I::Vararg{Int, nDim}) where {N, nDim, T, TA}
    index = Base._to_linear_index(A, I...)
    setindex!(A.data, v, index, cellᵢ, 1)
end

Base.@propagate_inbounds function setcellindex!(A::CellArray{SMatrix{Ni, Nj, T, N}, nDim, 0, TA}, v::Real, cellᵢ::Int, cellⱼ::Int, I::Vararg{Int, nDim}) where {N, Ni, Nj, nDim, T, TA}
    index = Base._to_linear_index(A, I...)
    linear_SMatrix = LinearIndices((1:Ni, 1:Nj))
    setindex!(A.data, v, index, linear_SMatrix[cellᵢ, cellⱼ], 1)
end
