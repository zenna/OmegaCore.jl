export ~, ciid

# # Conditional Independence
# It is useful to create independent and conditionally independent random variables
# This has meaning for both random and free variables

# In order to

struct CIID{ID, F}
  id::ID
  f::F
end

@inline (x::CIID)(ω) = x.f(appendscope(ω, x.id))

"""
Conditionally independent copy of `f`

if `g = ciid(f, id)` then `g` will be identically distributed with `f`
but conditionally independent given parents.
"""
@inline ciid(f, id) = ω -> f(appendscope(ω, id))
@inline ciid(f, id::Integer) = ciid(f, TupleID(id))

"Alias for `ciid(f, i)`"
@inline Base.:~(id, f) = ciid(f, id)

# FIXME: Give this a different syntax
@inline Base.:~(f) = ω -> f(rmscope(ω))

"append `id` to the scope"
appendscope(tω::T, id) where T = appendscope(tω, id, traithastag(T, Val{:scope}))
appendscope(tω, id, ::HasTag{:scope}) = updatetag(tω, append(id, tω.tag.scope))
appendscope(tω, id, _) = tag(tω, (scope = id,))

rmscope(ω::T) where T = rmscope(ω, traithastag(T, Val{:scope}))
rmscope(ω, ::HasTag{:scope}) = rmtag(ω, Val{:scope})
rmscope(ω, _) = ω