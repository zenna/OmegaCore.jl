module CIID

using ..Space
using ..Tagging
using ..IDS

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
@inline ciid(f, id::Integer) = ciid(f, tupleid(id)) #FIXME, remove

"Alias for `ciid(f, i)`"
@inline Base.:~(id, f) = ciid(f, id)

# FIXME: Give this a different syntax
@inline Base.:~(f) = ω -> f(rmscope(ω))

"append `id` to the scope"
appendscope(ω::T, id) where {T <: AbstractΩ} =
  appendscope(ω, id, traithastag(T, Val{:scope}))
appendscope(ω, id, ::HasTag{:scope}) =
  updatetag(ω, Val{:scope}, append(id, ω.tags.scope))
appendscope(ω, id, _) = tag(ω, (scope = id,))


rmscope(ω::T) where T = rmscope(ω, traithastag(T, Val{:scope}))
rmscope(ω, ::HasTag{:scope}) = rmtag(ω, Val{:scope})
rmscope(ω, _) = ω

"Current scope"
scope(ω) = ω.tags.scope
end