using Distributions
export LazyΩ
using Random
using ..IDS, ..Util, ..Tagging, ..RNG, ..Space, ..Var

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
traits(::Type{LazyΩ{TAGS, T}}) where {TAGS, T} = traits(TAGS)

Base.setindex!(ω::LazyΩ, value, id) = 
  ω.data[convertid(idtype(ω), id)] = value

function Var.recurse(exo::ExoRandVar, ω::LazyΩ)
  result = get(ω.data, exo, 0)
  if result === 0
    ω.data[member] = rand(rng(ω), dist)
  else
    result
  end::eltype(exo.class)
end

# function resolve(dist, id, ω::LazyΩ)
#   id_ = convertid(idtype(ω), id)
#   # id_ = id
#   if haskey(ω.data,  id_)
#     d, val = ω.data[id_]
#   else
#     ω.data[id_] = (dist, rand(rng(ω), dist))
#     d, val = ω.data[id_]
#   end
#   val::eltype(dist)   
# end