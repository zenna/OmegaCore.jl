export defΩ

using Distributions: Distribution
import Distributions: logpdf
using Random

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

"Default sample space"
defΩ(args...) = LazyΩ{Dict{TupleID, Any}}