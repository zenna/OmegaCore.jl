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
tag(om::SimpleΩ, tags) = SimpleΩ(om.data, mergef(mergetag, om.tags, tags))
rmtag(om::SimpleΩ, tag) = SimpleΩ(om.data, rmkey(om.tags, tag))
updatetag(om::SimpleΩ, tag, val) = LazyΩ(om.data, update(om.tags, tag, val))
traithastag(t::SimpleΩ{TAGS}, tag) where {TAGS} = traithastag(TAGS, tag)

# # Lazy Omega
# Lazily constructs random values.

"Sample space object"
struct LazyΩ{TAGS, T} <: AbstractΩ
  data::T
  tags::TAGS
end

LazyΩ{T}() where T = LazyΩ(T(), NamedTuple())
tag(om::LazyΩ, tags) = LazyΩ(om.data, mergef(mergetag, om.tags, tags))
rmtag(om::LazyΩ, tag) = LazyΩ(om.data, rmkey(om.tags, tag))
updatetag(om::LazyΩ, tag, val) = LazyΩ(om.data, update(om.tags, tag, val))
traithastag(t::Type{LazyΩ{TAGS, T}}, tag) where {TAGS, T} = traithastag(TAGS, tag)


# FIXME: get! should be omega type dependent
rng(x) = Random.GLOBAL_RNG
(T::Type{<:Distribution})(ω::LazyΩ, args...) =
  get!(ω.data, scope(ω), rand(rng(ω), T(args...)))::eltype(T)

sample(rng::AbstractRNG, ::Type{Ω}) where {Ω <: LazyΩ} = tagrng(Ω(), rng)

# # Where is init 
"Default sample space"
defΩ(args...) = LazyΩ{Dict{TupleID, Any}}