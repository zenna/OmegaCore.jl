using Distributions: Normal, Uniform, quantile, cdf, Distribution
import Distributions
using Random
using ..Space

export invert, primdist, distapply
export StdNormal, StdUniform

# # # Model
# struct Model{D, PARAMS}
#   x::D
#   params::PARAMS
# end

# # Todo, specialise this to 1,2,3,4,5 arguments
# (m::Model)(ω) = m.x((liftapply(p, ω) for p in m.params)...)(ω)  
# (x::Type{<:Distribution})(params...) = Model(x, params)

"Parameterless Distribution"
abstract type PrimitiveDist end
struct StdNormal <: PrimitiveDist end # FIXME: Should be parametezed by type
Base.eltype(::Type{StdNormal}) = Float64
Distributions.logpdf(::StdNormal, x) =
  Distributions.logpdf(Normal(0, 1), x)
Base.rand(rng::AbstractRNG, ::StdNormal) = rand(rng, Normal(0, 1))

struct StdUniform <: PrimitiveDist end
Base.eltype(::Type{StdUniform}) = Float64
Base.rand(rng::AbstractRNG, ::StdUniform) = rand(rng, Uniform(0, 1))

"`distapply(traits, d, id, ω)` apply `idth` member of distribution family d to ω"
function distapply end

(d::Distribution)(id, ω::AbstractΩ) =
  distapply(traits(ω), d, id, ω) #FIXME rename "distapply"

@inline distapply(traits, d::Distribution, id, ω) =
  f(d, id, ω)

@inline f(d::Normal, id, ω) =
  resolve(StdNormal(), id, ω) * d.σ + d.μ

@inline f(d::Distribution, id, ω) =
  quantile(d, resolve(StdUniform(), id, ω))

"""`primdist(d::Distribution)``
Primitive (parameterless) distribution that `d` is defined in terms of"""
function primdist end

primdist(d::Distribution) = StdUniform()
primdist(d::Normal) = StdNormal()

"""`invert(d::Distribution, val)`
If output of `val` is `val` what must its primitives have been?`"""
function invert end

invert(o::Normal, val) = (val / o.σ) - o.μ
invert(d::Distribution, val) = cdf(d, val)