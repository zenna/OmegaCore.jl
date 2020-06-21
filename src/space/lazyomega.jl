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

replacetags(ω::LazyΩ, tags) = LazyΩ(ω.data, tags)
traithastag(t::Type{LazyΩ{TAGS, T}}, tag) where {TAGS, T} = traithastag(TAGS, tag)

traits(::Type{LazyΩ{TAGS, T}}) where {TAGS, T} = traits(TAGS)

# FIXME: get! should be ωega type dependent
# (T::Type{<:Distribution})(ω::LazyΩ, args...) =
#   get!(ω.data, scope(ω), rand(rng(ω), T(args...)))::eltype(T)

# recurse(d::Distribution, ω::LazyΩ) =
#   get!(() -> rand(rng(ω), d), ω.data, scope(ω))::eltype(d)

# recurse(d::Member{<:Distribution}, ω::LazyΩ) = 
#   get!(() -> rand(rng(ω), d), ω.data, d.id)::eltype(d)

Base.setindex!(ω::LazyΩ, value, id) = 
  ω.data[id] = value

function resolve(dist, id, ω)
  d, val = get!(() -> (dist, rand(rng(ω), dist)), ω.data, id)
  val::eltype(dist)  
end

function Distributions.logpdf(ω::LazyΩ)
  reduce(ω.data; init = 0.0) do logpdf_, (id, (dist, val))
    logpdf_ + logpdf(dist, val)
  end
end

# # Where is init 
defΩ(args...) = LazyΩ{EmptyTags, Dict{defID(), Tuple{Any, Any}}}
defω(args...) = tagrng(defΩ()(), Random.GLOBAL_RNG)
