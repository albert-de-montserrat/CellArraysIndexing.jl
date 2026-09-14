# `getcellindex` generators
Base.@propagate_inbounds @inline function getcellindex(A::CellArray{SVector{N, T}, nDim, 0, TA}, cellᵢ::Int, I::Vararg{Int, nDim}) where {nDim, N, T, TA}
    index = _cell_linear_index(A, I...)
    @boundscheck begin
        _check_cell_storage(A, index)
        checkbounds(LinearIndices((1:N,)), cellᵢ)
    end
    @inbounds A.data[_cell_offset(A, cellᵢ, index)]
end

Base.@propagate_inbounds @inline function getcellindex(A::CellArray{SMatrix{Ni, Nj, T, N}, nDim, 0, TA}, cellᵢ::Int, cellⱼ::Int, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, TA, nDim}
    index = _cell_linear_index(A, I...)
    linear_SMatrix = LinearIndices((1:Ni, 1:Nj))
    component = linear_SMatrix[cellᵢ, cellⱼ]
    @boundscheck _check_cell_storage(A, index)
    @inbounds A.data[_cell_offset(A, component, index)]
end

# `setcellindex!` generators
Base.@propagate_inbounds function setcellindex!(A::CellArray{SVector{N, T}, nDim, 0, TA}, v::Real, cellᵢ::Int, I::Vararg{Int, nDim}) where {N, nDim, T, TA}
    index = _cell_linear_index(A, I...)
    @boundscheck begin
        _check_cell_storage(A, index)
        checkbounds(LinearIndices((1:N,)), cellᵢ)
    end
    @inbounds setindex!(A.data, v, _cell_offset(A, cellᵢ, index))
end

Base.@propagate_inbounds function setcellindex!(A::CellArray{SMatrix{Ni, Nj, T, N}, nDim, 0, TA}, v::Real, cellᵢ::Int, cellⱼ::Int, I::Vararg{Int, nDim}) where {N, Ni, Nj, nDim, T, TA}
    index = _cell_linear_index(A, I...)
    linear_SMatrix = LinearIndices((1:Ni, 1:Nj))
    component = linear_SMatrix[cellᵢ, cellⱼ]
    @boundscheck _check_cell_storage(A, index)
    @inbounds setindex!(A.data, v, _cell_offset(A, component, index))
end
