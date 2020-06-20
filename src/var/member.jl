using ..Tagging, ..IDS, ..Traits, ..Space

# export ~, ciid, Member

# # Conditional Independence
# It is useful to create independent and conditionally independent random variables
# This has meaning for both random and free variables

"The `id`th member of the family `f`"
struct Member{F, ID}
  id::ID
  f::F
end

# @inline (x::Member)(ω) = x.f(appendscope(ω, x.id))
@inline (x::Member)(ω) = x.f(x.id, ω)

Base.show(io::IO, x::Member) = print(io, x.id,"@",x.f)

"""
Conditionally independent copy of `f`

if `g = ciid(f, id)` then `g` will be identically distributed with `f`
but conditionally independent given parents.
"""
@inline ciid(f, id) = Variable(Member(id, f))   
@inline ciid(f, id::Integer, τ::Type{T} = defID()) where T =
  ciid(f, singletonid(T, id))

"`id ~ f` is an alias for `ciid(f, i)`"
@inline Base.:~(id, f) = ciid(f, id)

## What 

using Distributions: Normal
using Random

abstract type PrimitiveDist end
struct StdNormal <: PrimitiveDist
end

Base.rand(rng::AbstractRNG, ::StdNormal) = rand(rng, Normal(0, 1))

# recurse(d::Member{<:Distribution}, ω) =
#   resolve(d.f, d.id, ω)

# @inline (d::Member{<:Distribution})(ω) = 
#   resolve(d.f, d.id, ω)

recurse(d::Member{<:Normal}, ω) =
  go(d.f, d.id, ω)

@inline (d::Member{<:Normal})(ω) = 
  go(d.f, d.id, ω)

go(d::Normal, id, ω) = resolve(StdNormal(), id, ω) * d.σ + d.μ
# end