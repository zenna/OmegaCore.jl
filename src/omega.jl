export defΩ

using Distributions: Distribution
using Random

traithastag(t::AbstractΩ, tag) = traithastag(t.tags, tag)

# FIXME: DRY

# # Simple Omega
# Simplest, immutable Omegas

struct SimpleΩ{TAGS, T} <: AbstractΩ
  data::T
  tags::TAGS
end

(T::Type{<:Distribution})(π::SimpleΩ, args...) = ω.data[scope(ω)]
tag(ω::SimpleΩ, tags) = SimpleΩ(ω.data, mergef(mergetag, ω.tags, tags))
rmtag(ω::SimpleΩ, tag) = SimpleΩ(ω.data, rmkey(ω.tags, tag))
updatetag(ω::SimpleΩ, tag, val) = LazyΩ(ω.data, update(ω.tags, tag, val))
traithastag(t::SimpleΩ{TAGS}, tag) where {TAGS} = traithastag(TAGS, tag)

# # Lazy Omega
# Lazily constructs randω values.

"Sample space object"
struct LazyΩ{TAGS, T} <: AbstractΩ
  data::T
  tags::TAGS
end

LazyΩ{T}() where T = LazyΩ(T(), NamedTuple())
tag(ω::LazyΩ, tags) = LazyΩ(ω.data, mergef(mergetag, ω.tags, tags))
rmtag(ω::LazyΩ, tag) = LazyΩ(ω.data, rmkey(ω.tags, tag))
updatetag(ω::LazyΩ, tag, val) = LazyΩ(ω.data, update(ω.tags, tag, val))
traithastag(t::Type{LazyΩ{TAGS, T}}, tag) where {TAGS, T} = traithastag(TAGS, tag)


# FIXME: get! should be ωega type dependent
# (T::Type{<:Distribution})(ω::LazyΩ, args...) =
#   get!(ω.data, scope(ω), rand(rng(ω), T(args...)))::eltype(T)

(d::Distribution)(ω::LazyΩ) = get!(ω.data, scope(ω), rand(rng(ω), d))::eltype(d)

sample(rng::AbstractRNG, ::Type{Ω}) where {Ω <: LazyΩ} = tagrng(Ω(), rng)

# # Where is init 
"Default sample space"
defΩ(args...) = LazyΩ{Dict{TupleID, Any}}