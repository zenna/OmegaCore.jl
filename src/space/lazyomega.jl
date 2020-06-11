using Distributions
export LazyΩ
using ..IDS, ..Util, ..Tagging


# # Lazy Omega
# Lazily constructs randω values as they are needed

"Sample space object"

struct LazyΩ{TAGS, T} <: AbstractΩ
  data::T
  tags::TAGS
end

LazyΩ{T}() where T = LazyΩ(T(), Tags())

tag(ω::LazyΩ, tags) = LazyΩ(ω.data, mergef(mergetag, ω.tags, tags))
rmtag(ω::LazyΩ, tag) = LazyΩ(ω.data, rmkey(ω.tags, tag))
updatetag(ω::LazyΩ, tag, val) = LazyΩ(ω.data, update(ω.tags, tag, val))
traithastag(t::Type{LazyΩ{TAGS, T}}, tag) where {TAGS, T} = traithastag(TAGS, tag)

# FIXME: get! should be ωega type dependent
# (T::Type{<:Distribution})(ω::LazyΩ, args...) =
#   get!(ω.data, scope(ω), rand(rng(ω), T(args...)))::eltype(T)

recurse(d::Distribution, ω::LazyΩ) =
  get!(ω.data, scope(ω), rand(rng(ω), d))::eltype(d)

initΩ(rng::AbstractRNG, ::Type{Ω}) where {Ω <: LazyΩ} = tagrng(Ω(), rng)

# # Where is init 
defΩ(args...) = LazyΩ{Dict{defID(), Any}}