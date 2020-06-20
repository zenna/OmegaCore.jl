using Distributions: Distribution

struct Model{D, PARAMS}
  x::D
  params::PARAMS
end

# Todo, specialise this to 1,2,3,4,5 arguments
(m::Model)(ω) = m.x((liftapply(p, ω) for p in m.params)...)(ω)  
(x::Type{<:Distribution})(params...) = Model(x, params)

const StdNormal = Normal(0, 1)

"Like a Normal Distribution but more normal"
struct Ordinary{MU, SIG}
  μ::MU
  σ::SIG
end

(o::Ordinary)(ω) = (StdNormal(ω) + o.μ) * o.σ

"If output of `o` is `val` what must its noise parameter must have been?`"
invert(::Ordinary, val) = (val / o.σ) - o.μ

## When we're executing o(ω), if the variable is conditioned then we can
## update ω with the appropriate value for the standard normal