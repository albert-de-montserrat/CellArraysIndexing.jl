module CellArraysIndexingExtCUDA

import CellArraysIndexing
using CUDA, CellArrays

DevCellArray = :CUDACellArray
include("codegen.jl")

end
