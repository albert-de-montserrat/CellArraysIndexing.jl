module CellArraysIndexing

using CellArrays, StaticArrays

include("cells.jl")
export @cell, getcell, setcell!

include("indices.jl")
export @index, getcellindex, setcellindex!

end # module CellArraysIndexing
