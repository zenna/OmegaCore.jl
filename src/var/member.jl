using ..Tagging, ..IDS, ..Traits, ..Space

export Member
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

using Distributions: Normal, Uniform, quantile
using Random

abstract type PrimitiveDist end
struct StdNormal <: PrimitiveDist
end

Distributions.logpdf(::StdNormal, x) =
  Distributions.logpdf(Normal(0, 1), x)

(d::Distribution)(id, ω::AbstractΩ) =
  go(traits(ω),  d, id, ω)

Base.rand(rng::AbstractRNG, ::StdNormal) = rand(rng, Normal(0, 1))

struct StdUniform <: PrimitiveDist end

Base.eltype(::Type{StdUniform}) = Float64
Base.eltype(::Type{StdNormal}) = Float64
Base.rand(rng::AbstractRNG, ::StdUniform) = rand(rng, Uniform(0, 1))

go(traits, d::Normal, id, ω) = @show(resolve(StdNormal(), id, ω)) * d.σ + d.μ
go(traits, d::Distribution, id, ω) = quantile(d, resolve(StdUniform(), id, ω))

# To generalize this
# Genral method to reframe a distribution in these terms?
# rewrite go in a generic form
# type instability