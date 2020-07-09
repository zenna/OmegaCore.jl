using Distributions
export LazyΩ
using Random
using ..IDS, ..Util, ..Tagging, ..RNG

"Lazily constructs randp, values as they are needed"
struct LazyΩ{TAGS <: Tags, T} <: AbstractΩ
  data::T
  tags::TAGS
end

const EmptyTags = Tags{(),Tuple{}}
LazyΩ{EmptyTags, T}() where T = LazyΩ(T(), Tags())

"Construct `LazyΩ` from `rng` -- `ω.data` will be generated from `rng`"
LazyΩ{T}(rng::AbstractRNG) where T = tagrng(LazyΩ{T}(), rng)

idtype(ω::LazyΩ{TAGS, Dict{T, V}}) where {TAGS, T, V} = T
ids(ω::LazyΩ) = keys(ω.data)

replacetags(ω::LazyΩ, tags) = LazyΩ(ω.data, tags)
# traithastag(t::Type{LazyΩ{TAGS, T}}, tag) where {TAGS, T} = traithastag(TAGS, tag)
traits(::Type{LazyΩ{TAGS, T}}) where {TAGS, T} = traits(TAGS)

Base.setindex!(ω::LazyΩ, value, id) = 
  ω.data[convertid(idtype(ω), id)] = value

function resolve(dist, id, ω)
  id_ = convertid(idtype(ω), id)
  # id_ = id
  d, val = get!(() -> (dist, rand(rng(ω), dist)), ω.data, id_)
  val::eltype(dist)  
end

# resolve(dist::LazyΩ{Tags, T{ID}}, id::ID, ω) where {ID, T} = 
#   @assert false

