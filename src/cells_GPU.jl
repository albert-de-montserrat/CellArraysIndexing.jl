
# `getcell` generators
Base.@propagate_inbounds @inline function getcell(A::CellArray{SVector{N, T}, nDim, 0, TA}, I::Vararg{Int, nDim}) where {N, nDim, T, TA}
    index = _cell_linear_index(A, I...)
    @boundscheck _check_cell_storage(A, index)
    SVector{N, T}(ntuple(k -> (@inbounds A.data[_cell_offset(A, k, index)]), Val(N)))
end

Base.@propagate_inbounds @inline function getcell(A::CellArray{SMatrix{Ni, Nj, T, N}, nDim, 0, TA}, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, TA, nDim}
    index = _cell_linear_index(A, I...)
    @boundscheck _check_cell_storage(A, index)
    SMatrix{Ni, Nj, T, N}(ntuple(k -> (@inbounds A.data[_cell_offset(A, k, index)]), Val(N)))
end

# `setcell!` generators
@generated function setcell!(A::CellArray{SVector{N, T}, nDim, 0, TA}, v::AbstractVector, I::Vararg{Int, nDim}) where {N, nDim, T, TA}
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

@generated function setcell!(A::CellArray{SMatrix{Ni, Nj, T, N}, nDim, 0, TA},  v::AbstractMatrix, I::Vararg{Int, nDim}) where {N, Ni, Nj, T, TA, nDim}
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
