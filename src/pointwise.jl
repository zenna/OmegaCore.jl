module Pointwise

# This is a bad idea..
# to haev pointwise depend on global state


export pw, ==ₚ
# using ..OmegaCore: defΩ

# methodexists(f::Type{F}, x::Type{X}, y::Type{Y}) where {F <: Function, X, Y} =
#   length(methods(F.instance, (X, Y))) > 0

# methodexists(f::Type{F}, x::Type{X}) where {F <: Function, X} =
#   length(methods(F.instance, (X,))) > 0

# methodexists(f::Type{F}, x::Type{X}) where {F, X} =
#   length(methods(F, (X,))) > 0

# methodexists(f::Type{D}, x::Type{X}, y::Type{Y}) where {D, X, Y} =
#     length(methods(D, (X, Y))) > 0

# String(x, y)
# "adada"(x, y)

# @inline @generated function apply(f, ω)
#   if methodexists(f, ω)
#     :(f(ω))
#   else
#     :(f)
#   end
# end

# pw(f, x, y) = f(apply(x, ω), apply(y, ω))


# (::PointWise)(ω) = 

"""
Pointwise application.

Pointwise function application gives meaning to expressions such as `x + y`  when `x` and `y` are functions.
That is `x + y` is the function `ω -> x(ω) + y(ω)`.

Pointwise works when `x` is a function but `y` is a constant, and so on.

Principle:
if x(ω) is defined or y(ω) is defined and f(x, y) is not defined then
do pointwise application.

Is it safe to check whether a method exists?

```
x1 = 3 + 2
x2 = pw(+, 3, 2)
@assert x1 == x2

x(ω) = unif(ω)
y = pw(+, x, 4)
```
"""
function pw end

# @generated function pw(f, args...)
#   exists = [methodexists(x, defΩ()) for x in args]
#   if any(exists)
#     mod_args = [exist ? :(args[$i]) : :(args[$i](ω)) for (i, exist) in enumerate(exists)]
#     o = :(ω -> f($(mod_args...)))
#     Core.println(o)
#     o
#   else
#     :(f(args...))
#   end
# end

@inline constapply(f, ω) = f
@inline constapply(f::DataType, ω) = f(ω)
@inline constapply(f::Function, ω) = f(ω)
@inline pw(f, x) = ω -> f(constapply(x, ω))
@inline pw(f, x1, x2) = ω -> f(constapply(x1, ω), constapply(x2, ω))
@inline pw(f, x1, x2, x3) = ω -> f(constapply(x1, ω), constapply(x2, ω), constapply(x1, ω), constapply(x3, ω))
@inline pw(f, x1, args...) = ω -> f(constapply(x1, ω), (constapply(x, ω) for x in args)...)

# using Base.Iterators: product, filter

# const MAXPOINTWISEARITY = 4
# const Bools = (true, false)
# for i = 1:MAXPOINTWISEARITY
#   for comb in filter(any, product((Bools for j = 1:i)...))
#     display(comb)
#   end
#   println()
# end

# # Primitives

export ==ₚ, >=ₚ, <=ₚ
@inline x ==ₚ y = pw(==, x, y)
@inline x >=ₚ y = pw(>>, x, y)
@inline x <=ₚ y = pw(<=, x, y)


end