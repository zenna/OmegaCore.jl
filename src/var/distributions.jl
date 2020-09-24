using Distributions: Normal, Uniform, quantile, cdf, Distribution
import Distributions
using Random: AbstractRNG

export invert, primdist, distapply
export StdNormal, StdUniform
export PrimDist, ExoRandVar

"Primitive Distribution"
abstract type PrimDist end

"An exogenous random variable"
ExoRandVar{F, ID} = Member{F, ID} where {F <: PrimDist}

struct StdNormal{T<:Real} <: PrimDist end
Base.eltype(::Type{StdNormal{T}}) where T = T
Distributions.logpdf(::StdNormal{T}, x) where T =
  Distributions.logpdf(Normal(zero(T), one(T)), x)
Base.rand(rng::AbstractRNG, ::StdNormal{T}) where {T} = rand(rng, Normal(zero(T), one(T)))

# This is called from dispatch
@inline (d::Normal{T})(id, ω) where T =
  @show(Member(id, StdNormal{T}()))(ω) * d.σ + d.μ


# struct StdUniform <: PrimDist end
# Base.eltype(::Type{StdUniform}) = Float64
# Base.rand(rng::AbstractRNG, ::StdUniform) = rand(rng, Uniform(0, 1))
# @inline Space.recurse(d::Distribution, id, ω) =
#   quantile(d, resolve(StdUniform(), id, ω))
# # @inline (d::Distribution)(id, ω) =
# #   quantile(d, resolve(StdUniform(), id, ω))

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


  
  