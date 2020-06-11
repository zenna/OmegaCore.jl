export defΩ, SimpleΩ, LazyΩ

using ..IDS, ..Util, ..Tagging
using Distributions: Distribution
using Random: AbstractRNG

# # Concrete
# These are concrete data structures that implement the AbstractΩ structure,
# associating ids with values. 

traithastag(t::AbstractΩ, tag) = traithastag(t.tags, tag)
hastag(ω::AbstractΩ, tag) = hastag(ω.tags, tag)

# FIXME: DRY

# # Simple Omega
# Simplest, immutable Omegas

struct SimpleΩ{TAGS, T} <: AbstractΩ
  data::T
  tags::TAGS
end
``
SimpleΩ(data) = SimpleΩ(data, Tags())

(T::Type{<:Distribution})(π::SimpleΩ, args...) = ω.data[scope(ω)]
tag(ω::SimpleΩ, tags) = SimpleΩ(ω.data, mergef(mergetag, ω.tags, tags))
rmtag(ω::SimpleΩ, tag) = SimpleΩ(ω.data, rmkey(ω.tags, tag))
updatetag(ω::SimpleΩ, tag, val) = SimpleΩ(ω.data, update(ω.tags, tag, val))
traithastag(t::Type{SimpleΩ{TAGS, T}}, tag) where {TAGS, T} = traithastag(TAGS, tag)

recurse(d::Distribution, ω::SimpleΩ) = getindex(ω.data, scope(ω))::eltype(d)