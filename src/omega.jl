using Distributions: Distribution
import Distributions: logpdf
using Random

(T::Type{<:Distribution})(ω::TAG{<:AbstractΩ}, args...) = T(proj(ω, (1,)), args...)

# # Simple Omega
# Simplest, immutable Oemgas

struct SimpleΩ{T} <: AbstractΩ
  data::T
end

(T::Type{<:Distribution})(ωπ::Proj{<:SimpleΩ}, args...) = π.ω.data[π.id]
finite(π::Proj{<:SimpleΩ}, range) =  π.ω.data[π.id]

# # Lazy Omega
# Lazily constructs random values.

"Sample space object"
struct LazyΩ{T} <: AbstractΩ
  data::T
end

LazyΩ{T}() where T = LazyΩ(T())

# FIXME: get! should be omega type dependent
rng(x) = Random.GLOBAL_RNG
(T::Type{<:Distribution})(ωπ::Proj{<:LazyΩ}, args...) = get!(ωπ.ω.data, ωπ.id, rand(rng(ωπ), T(args...)))

sample(rng::AbstractRNG, ::Type{Ω}) where {Ω <: LazyΩ} = tagrng(Ω(), rng)

# Where is init defined?
finite(π::Proj{<:LazyΩ}, range) =  get!(π.ω.data, π.id, init(range))

# # Static Omega
# Static Omega

# "Static Omega"
# struct StaticΩ{F} <: AbstractΩ
#   f::F
# end

# g(x) =   

# # Defaults

"Default sample space"
defΩ(args...) = LazyΩ{Dict{ID, Any}}




# WHat's wrong with this
# # - Should I use different types for param for distribution.
# =
# Another way is to merge the ids as we did before



# 4. Distributions over parameterixed functions. (unsure)

# - What's to stop things from returning the wrong type of value
# - type constraints
# - unclear where init is deifned, or if thats how you want to definer params

## How are we going to use this.  1. to just run the model
## To manupulate these values
# - should i be using a trait instead?
# - doesn't work with rand