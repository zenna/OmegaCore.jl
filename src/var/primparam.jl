export unit, bounded, choice, finite
export isprimparam, PrimParam

# # Primitives
# These are primitive parameters.

"""
Choice over Boolean valued variable.

`choice(ϕ, T)`
"""
function choice end

"""
A variable of type T bounded between 0 and 1

```
x(ϕ) = unit(ϕ, Float16)
```
"""
function unit end

"""
A variable of type T bounded between `lb` and `ub`

```julia
function f(φ)
  x = 1 ~ bounded(φ, Float64, 0.0, 10.0)
  y = 2 ~ bounded(φ, Float64, 0.0, 10.0)
  x + y
end
```
"""
bounded(φ, T, lb, ub) = unit(φ, T) * (ub - lb) + lb

"""
Variable ranging over finite set

```
finite(φ, 1:10)
finite(φ, (1,2,3))
```
"""
function finite end


"Trait: Is `T` a primitive parameter function -- by default no"
isprimparam(::Type{T}) where T = false
# isprimparam(t::Type{T}) where {T <: Union{choice, unit, finite, bounded}} = true
PrimParam = Union{typeof(choice), typeof(unit), typeof(finite), typeof(bounded)}