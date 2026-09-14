module CellArraysIndexing

using CellArrays, StaticArrays

# Check logical coordinates before flattening: a physically valid linear offset
# can otherwise hide an invalid Cartesian index such as (5, 1) in a 4x4 grid.
Base.@propagate_inbounds function _cell_linear_index(A, I...)
    @boundscheck checkbounds(A, I...)
    return Base._to_linear_index(A, I...)
end

@inline function _check_cell_storage(A::CellArray{S,D,B}, index) where {S,D,B}
    # Validate the layout invariant, not a second index-dependent bound. This
    # check can be hoisted out of loops and also protects the linear offsets.
    expected = B == 1 ? (1, length(S), length(A)) : (length(A), length(S), 1)
    size(A.data) == expected || throw(DimensionMismatch("backing storage no longer matches the cell layout"))
    return nothing
end

# CellArray construction validates the storage shape. A three-dimensional Array
# cannot be resized through the supported Array API, so this invariant remains
# valid for CPU storage and does not need a per-access check.
@inline _check_cell_storage(A::CPUCellArray, index) = nothing

@inline _cell_offset(A::CellArray{S,D,1}, k, index) where {S,D} =
    (index - 1) * length(S) + k
@inline _cell_offset(A::CellArray{S,D,0}, k, index) where {S,D} =
    index + (k - 1) * length(A)

include("cells_CPU.jl")
include("cells_GPU.jl")
export getcell, setcell!

include("indices_CPU.jl")
include("indices_GPU.jl")
export getcellindex, setcellindex!

include("macros.jl")
export @index, @cell

end # module CellArraysIndexing
