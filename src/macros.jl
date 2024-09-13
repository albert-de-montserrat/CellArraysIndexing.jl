# @index

macro index(ex)
    ex = ex.head === (:(=)) ? _setindex!(ex) : _getindex(ex)
    return :($(esc(ex)))
end

@inline _getindex(ex) = Expr(:call, getcellindex, ex.args...)
@inline function _setindex!(ex)
    return Expr(
        :call, setcellindex!, ex.args[1].args[1], ex.args[2], ex.args[1].args[2:end]...
    )
end

# @cell

macro cell(ex)
    ex = ex.head === (:(=)) ? _setcell!(ex) : _getcell(ex)
    return :($(esc(ex)))
end

@inline _getcell(ex) = Expr(:call, getcell, ex.args...)
@inline function _setcell!(ex)
    return Expr(
        :call, setcell!, ex.args[1].args[1], ex.args[2], ex.args[1].args[2:end]...
    )
end