using Distributions: Normal, Uniform, quantile, cdf, Distribution
import Distributions
using Random
using ..Space

export invert, primdist, distapply
export StdNormal, StdUniform

"returntype(x, ω) is return type of variable `x` on space `ω`"
function returntype end

"Parameterless Distribution"
abstract type ParamFreeDist end

(p::ParamFreeDist)(id, ω) = resolve(p, id, ω)

struct StdNormal <: ParamFreeDist end # FIXME: Should be parametezed by type
Base.eltype(::Type{StdNormal}) = Float64
Distributions.logpdf(::StdNormal, x) =
  Distributions.logpdf(Normal(0, 1), x)
Base.rand(rng::AbstractRNG, ::StdNormal) = rand(rng, Normal(0, 1))
Base.rand(rng::AbstractRNG, ::StdNormal, shape::Dims) = rand(rng, Normal(0, 1), shape)


struct StdUniform <: ParamFreeDist end
Base.eltype(::Type{StdUniform}) = Float64
Base.rand(rng::AbstractRNG, ::StdUniform) = rand(rng, Uniform(0, 1))
badger(rng::AbstractRNG, ::StdUniform, shape::Dims) = rand(rng, Uniform(0, 1), shape)
# FIXME: Generalize to all dist


# "`distapply(traits, d, id, ω)` apply `idth` member of distribution family d to ω"
# function distapply end

# (d::Distribution)(id, ω::AbstractΩ) =
#   distapply(traits(ω), d, id, ω) #FIXME rename "distapply"

# # Primitive distribution families
# @inline distapply(traits, d::Distribution, id, ω) =
#   distapply_(d, id, ω)

# @inline distapply_(d::Normal, id, ω) =
#   resolve(StdNormal(), id, ω) * d.σ + d.μ

# @inline distapply_(d::Distribution, id, ω) =
#   quantile(d, resolve(StdUniform(), id, ω))

## 
@inline Space.recurse(d::Normal, id, ω) =
  resolve(StdNormal(), id, ω) * d.σ + d.μ

@inline Space.recurse(d::Distribution, id, ω) =
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


  
  