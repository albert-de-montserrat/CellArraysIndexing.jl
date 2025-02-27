"""
    getcell(A, I)

Get the cell at the specified indices `I` from the CellArray `A`.

# Arguments
- `A::CellArray`: The CPUCellArray from which to retrieve the cell.
- `I::Vararg{Int, nDim}`: The indices specifying the position of the cell in the CPUCellArray.

# Returns
- The cell at the specified indices `I`.
"""
Base.@propagate_inbounds @inline function getcell(A::CPUCellArray{SVector{N, T}, nDim, 1, T}, I::Vararg{Int, nDim}) where {N, nDim, T}
    index = Base._to_linear_index(A,I...)
    SVector{N, T}(A.data[1,i,index] for i in 1:N)
end

Base.@propagate_inbounds @inline function getcell(A::CPUCellArray{SMatrix{Ni, Nj, T, N}, nDim, 1, T}, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, nDim}
    index = Base._to_linear_index(A, I...)
    linear_SMatrix = LinearIndices((1:Ni, 1:Nj))
    SMatrix{Ni, Nj, T}(A.data[1, linear_SMatrix[i, j], index] for i in 1:Ni, j in 1:Nj)
end

"""
    setcell!(A, v::AbstractVector, I)

Set the value of a cell in a CPUCellArray to the value of `v::AbstractArray`.

# Arguments
- `A::CellArray`: The CPUCellArray in which to set the cell value.
- `v::AbstractVector`: The value to set the cell to.
- `I::Vararg{Int, nDim}`: The indices of the cell to set.
"""
@generated function setcell!(A::CPUCellArray{SVector{N, T}, nDim, 1, T}, v::AbstractVector, I::Vararg{Int, nDim}) where {N, nDim, T}
    quote
        Base.@_inline_meta
        Base.@_propagate_inbounds_meta
        index = Base._to_linear_index(A, I...)
        Base.@nexprs $N i -> setindex!(A.data, v[i], 1, i, index)
    end
end

@generated function setcell!(A::CPUCellArray{SMatrix{Ni, Nj, T, N}, nDim, 1, T},  v::AbstractMatrix, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, nDim}
    quote
        Base.@_inline_meta
        Base.@_propagate_inbounds_meta
        index = Base._to_linear_index(A, I...)
        linear_SMatrix = LinearIndices((1:$Ni, 1:$Nj))
        Base.@nexprs $Ni i -> 
            Base.@nexprs $Nj j ->
                setindex!(A.data, v[i,j], 1, linear_SMatrix[i, j], index)
    end
end
