module CellArraysIndexingExtAMDGPU

import CellArraysIndexing
using AMDGPU, CellArrays

DevCellArray = :AMDGPUCellArray
include("codegen.jl")

end
