using Distributions
export LazyΩ
using ..IDS, ..Util, ..Tagging, ..RNG

"Lazily constructs randp, values as they are needed"
struct LazyΩ{TAGS, T} <: AbstractΩ
  data::T
  tags::TAGS
end

LazyΩ{T}() where T = LazyΩ(T(), Tags())

"Construct `LazyΩ` from `rng` -- `ω.data` will be generated from `rng`"
LazyΩ{T}(rng::AbstractRNG) where T = tagrng(LazyΩ{T}(), rng)

replacetags(ω::LazyΩ, tags) = LazyΩ(ω.data, tags)
traithastag(t::Type{LazyΩ{TAGS, T}}, tag) where {TAGS, T} = traithastag(TAGS, tag)

traits(::Type{LazyΩ{TAGS, T}}) where {TAGS, T} = traits(TAGS)

# FIXME: get! should be ωega type dependent
# (T::Type{<:Distribution})(ω::LazyΩ, args...) =
#   get!(ω.data, scope(ω), rand(rng(ω), T(args...)))::eltype(T)

recurse(d::Distribution, ω::LazyΩ) =
  get!(() -> rand(rng(ω), d), ω.data, scope(ω))::eltype(d)

# # Where is init 
defΩ(args...) = LazyΩ{Dict{defID(), Any}}