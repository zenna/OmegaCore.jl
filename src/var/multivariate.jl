using Distributions: Multivariate, Distribution
using ..Space

# # Multivariate
export Mv
"""
Multivariate distribution: Random array where each variable is ciid given
values for parameters.

`Mv(dist, shape)`

```julia
x = Mv(Uniform(0, 1), (100,))
randsample(x)
```

"""
struct Mv{T, SHAPE}
  dist::T
  shape::SHAPE
end  

traitlift(::Type{<:Mv}) = Lift()

# Base.eltype(Mv{T}) where {T} = 


prim(d::Normal) = StdNormal()

func(d::Normal, x) = x * d.σ + d.μ

@inline Space.recurse(mv::Mv{<:Distribution}, id, ω) =
  map(x -> func(mv.dist, x), resolve(Mv(prim(mv.dist), mv.shape), id, ω))

Base.rand(rng::AbstractRNG, mv::Mv{<:PrimitiveDist}) = 
  rand(rng, mv.dist, mv.shape)
