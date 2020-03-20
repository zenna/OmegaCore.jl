import Distributions

"Constant distribution"
struct Constant{T}
  val::T
end

Distributions.logpdf(c::Constant, x::T) where {T <: Real} = x == c ? one(T) : zero(T)
Distributions.mean(c::Constant{<:Real}) = c.val
Distributions.median(c::Constant{<:Real}) = c.val
Distributions.mode(c::Constant{<:Real}) = c.val
Distributions.var(c::Constant{T}) where {T <: Real} = zero(T)

Base.rand(rng, c::Constant) = c.val

