module CIID

using Spec
using ..Space, ..Tagging, ..IDS, ..Var, ..Traits

export ~, ciid

# # Conditional Independence
# It is useful to create independent and conditionally independent random variables
# This has meaning for both random and free variables

"Variable that introduces scope"
struct Scoped{ID, F}
  id::ID
  f::F
end

@inline (x::Scoped)(ω) = x.f(appendscope(ω, x.id))

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
@inline Base.:~(f) = ω -> f(rmscope(ω))

end