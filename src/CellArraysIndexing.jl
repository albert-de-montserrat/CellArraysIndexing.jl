module CellArraysIndexing

using CellArrays, StaticArrays

include("cells_CPU.jl")
include("cells_GPU.jl")
export getcell, setcell!

include("indices_CPU.jl")
include("indices_GPU.jl")
export getcellindex, setcellindex!

include("macros.jl")
export @index, @cell

end # module CellArraysIndexing
