using Distributions
export LazyΩ
using ..IDS, ..Util, ..Tagging

"Lazily constructs randp, values as they are needed"
struct LazyΩ{TAGS, T} <: AbstractΩ
  data::T
  tags::TAGS
end

LazyΩ{T}() where T = LazyΩ(T(), Tags())
replacetags(ω::LazyΩ, tags) = LazyΩ(ω.data, tags)
traithastag(t::Type{LazyΩ{TAGS, T}}, tag) where {TAGS, T} = traithastag(TAGS, tag)

# FIXME: get! should be ωega type dependent
# (T::Type{<:Distribution})(ω::LazyΩ, args...) =
#   get!(ω.data, scope(ω), rand(rng(ω), T(args...)))::eltype(T)

recurse(d::Distribution, ω::LazyΩ) =
  get!(ω.data, scope(ω), rand(rng(ω), d))::eltype(d)

initΩ(rng::AbstractRNG, ::Type{Ω}) where {Ω <: LazyΩ} = tagrng(Ω(), rng)

# # Where is init 
defΩ(args...) = LazyΩ{Dict{defID(), Any}}