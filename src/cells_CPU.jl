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
    index = _cell_linear_index(A, I...)
    @boundscheck _check_cell_storage(A, index)
    SVector{N, T}(ntuple(k -> (@inbounds A.data[_cell_offset(A, k, index)]), Val(N)))
end

Base.@propagate_inbounds @inline function getcell(A::CPUCellArray{SMatrix{Ni, Nj, T, N}, nDim, 1, T}, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, nDim}
    index = _cell_linear_index(A, I...)
    @boundscheck _check_cell_storage(A, index)
    SMatrix{Ni, Nj, T, N}(ntuple(k -> (@inbounds A.data[_cell_offset(A, k, index)]), Val(N)))
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
        index = _cell_linear_index(A, I...)
        @boundscheck begin
            _check_cell_storage(A, index)
            checkbounds(v, 1:$N)
        end
        @inbounds Base.@nexprs $N i -> setindex!(A.data, v[i], _cell_offset(A, i, index))
    end
end

@generated function setcell!(A::CPUCellArray{SMatrix{Ni, Nj, T, N}, nDim, 1, T},  v::AbstractMatrix, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, nDim}
    # Only reorder reads for an immutable static RHS of the exact cell shape.
    # General matrices retain their original traversal and aliasing behavior.
    stores = if v <: SMatrix{Ni,Nj}
        :(Base.@nexprs $N k -> setindex!(A.data, v[k], _cell_offset(A, k, index)))
    else
        :(Base.@nexprs $Ni i -> Base.@nexprs $Nj j ->
            setindex!(A.data, v[i,j], _cell_offset(A, linear_SMatrix[i, j], index)))
    end
    quote
        Base.@_inline_meta
        Base.@_propagate_inbounds_meta
        index = _cell_linear_index(A, I...)
        linear_SMatrix = LinearIndices((1:$Ni, 1:$Nj))
        @boundscheck begin
            _check_cell_storage(A, index)
            checkbounds(v, 1:$Ni, 1:$Nj)
        end
        @inbounds $stores
    end
end
