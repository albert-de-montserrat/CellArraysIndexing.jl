"""
    getcellindex(A, cellᵢ, I)

Get the `cellᵢ` index of a specific cell in a `CellArray``.

# Arguments
- `A::CPUCellArray{SVector, nDim, 1, T}`: The CPUCellArray to search in.
- `cellᵢ::Int`: The index of the cell to retrieve.
- `I::Vararg{Int, nDim}`: The indices of the elements within the cell.

# Returns
- The index of the specified cell.
"""
Base.@propagate_inbounds @inline function getcellindex(A::CPUCellArray{SVector{N, T}, nDim, 1, T}, cellᵢ::Int, I::Vararg{Int, nDim}) where {nDim, N, T}
    index = Base._to_linear_index(A,I...)
    A.data[1, cellᵢ,index]
end

Base.@propagate_inbounds @inline function getcellindex(A::CPUCellArray{SMatrix{Ni, Nj, T, N}, nDim, 1, T}, cellᵢ::Int, cellⱼ::Int, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, nDim}
    index = Base._to_linear_index(A, I...)
    linear_SMatrix = LinearIndices((1:Nj, 1:Nj))
    A.data[1, linear_SMatrix[cellᵢ, cellⱼ], index]
end

"""
    setcellindex!(A, v, cellᵢ, I)

Set the `cellᵢ` index of a specific cell in a `CellArray`` to the value of the scalar `v`.

# Arguments
- `A::CPUCellArray{SVector, nDim, 1, T}`: The CPUCellArray to search in.
- `v<:Real`: new value of the cell index. 
- `cellᵢ::Int`: The index of the cell to retrieve.
- `I::Vararg{Int, nDim}`: The indices of the elements within the cell.

# Returns
- The index of the specified cell.
"""
Base.@propagate_inbounds function setcellindex!(A::CPUCellArray{SVector{N, T}, nDim, 1, T}, v::T, cellᵢ::Int, I::Vararg{Int, nDim}) where {nDim, N, T}
    index = Base._to_linear_index(A, I...)
    setindex!(A.data, v, 1, cellᵢ, index)
end

Base.@propagate_inbounds function setcellindex!(A::CPUCellArray{SMatrix{Ni, Nj, T, N}, nDim, 1, T}, v::T, cellᵢ::Int, cellⱼ::Int, I::Vararg{Int, nDim}) where {N, Ni, Nj, nDim, T}
    index = Base._to_linear_index(A, I...)
    linear_SMatrix = LinearIndices((1:Nj, 1:Nj))
    setindex!(A.data, v, 1, linear_SMatrix[cellᵢ, cellⱼ], index)
end
