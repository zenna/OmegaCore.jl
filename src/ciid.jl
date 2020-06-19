module CIID

using Spec
using ..Space, ..Tagging, ..IDS, ..Var, ..Traits

export ~, ciid, share, Scoped

# # Conditional Independence
# It is useful to create independent and conditionally independent random variables
# This has meaning for both random and free variables

"Variable that introduces scope"
struct Scoped{ID, F}
  id::ID
  f::F
end

@inline (x::Scoped)(ω) = x.f(appendscope(ω, x.id))

Base.show(io::IO, x::Scoped) = print(io, x.id,"@",x.f)

"""
Conditionally independent copy of `f`

if `g = ciid(f, id)` then `g` will be identically distributed with `f`
but conditionally independent given parents.
"""
@inline ciid(f, id) = Variable(Scoped(id, f))   
@inline ciid(f, id::Integer, τ::Type{T} = defID()) where T =
  ciid(f, singletonid(T, id)) #FIXME, remove

"Alias for `ciid(f, i)`"
@inline Base.:~(id, f) = ciid(f, id)

# FIXME: Give this a different syntax

"""
`share(f)`

If `f` is a variable that you want to be shared as the parent of many other
variables within a class, use `share(f)(ω)` instead of `f(ω)`.

Suppose we have the following model:
```julia
x = ~ Normal(0, 1)
function f(ω)
  a = ~ Normal(0, 0.001)(ω) + a(ω)
end
f1 = ~ f
f2 = ~ f
f3 = ~ f
randsample((f1, f2, f3))
```

We are hoping that `f1`, `f2` and `f3` will have `a` as a parent.
But this won't be the case; they will instead be completely independent.

Tp ensure that `a` is a shared parent of them all use `shared`

```julia
x = ~ Normal(0, 1)
function f(ω)
  a = ~ Normal(0, 0.001)(ω) + share(a)(ω)
end
f1 = ~ f
f2 = ~ f
f3 = ~ f
randsample((f1, f2, f3))
```
"""
@inline share(f) = ω -> f(rmscope(ω))

""
# @inline Base.:~(f) = share(f)

end