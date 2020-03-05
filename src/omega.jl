
# # Sample Space / Trace

"Sample space object"
struct Ω{T}
  data::T
end

# A projection of ω to some index id is simply ω[id]
# ΩProj is a symbolic representation of this projection
# It's useful to maintain a reference to the parent ω

"id'th element of ω, with reference to parent"
struct ΩProj{OM}
  ω::OM
  id::ID
end

"Project `ω` onto `id`"
proj(ω::Ω, id) = ΩProj(ω, id)
proj(tω::Tagged{Ω{Z}}, id) where {Z} = copytag(tω, proj(tω.val, id))

# # Sampling

# "Sample a random ω ∈ Ω"
# sample(::Type{Ω{T}}) where T = Ω(T())
# sample(f) = f(sample(Ω))

# # Primitive Distributions

# FIXME: get! should be omega type dependent
(T::Type{<:Distribution})(ωπ::ΩProj, args...) =
  get!(ωπ.ω.data, ωπ.id, rand(T(args...)))

(T::Type{<:Distribution})(ω::TAG{Ω{Z}}, args...) where {Z} = T(proj(ω, (1,)), args...)

# # Log pdf

"Wraps val, and is mutable"
mutable struct Wrapper{T}
  val::T
end

"Logdensity of `rv` on input `ω`"
function logpdf(rv, ω)
  # FIXME: Don't double count
  tω = Tagged(ω, (logpdf = Wrapper(0.0), seen = Set{ID}()))
  rv(tω)  
  tω.tag.logpdf.val
end

function (T::Type{<:Distribution})(ωπ::Tagged{ΩProj{OM}}, args...) where {OM}
  ctx = ωπ.tag
  ret = T(ωπ.val, args...)

  # Avoid double counting
  if ωπ.val.id ∉ ctx.seen
    ctx.logpdf.val += logpdf(T(args...), ret)
    push!(ctx.seen, ωπ.val.id)
  end
  ret
end

# # (Conditional) Independence

# TODO1. when there is a scope then we need to change behaviour of projection
# TODO2. This does iid, if we want ciid  then we'll need something more

appendscope(ω, id::ID) = tag(ω, (scope = ID,))
rmscope(ω::Tagged) = rmkeys(ω, :scope)

@inline ciid(f, id) = ω -> f(appendscope(ω, id))
~(id, f) = ciid(f, id)
~(f) = ω -> f(rmscope(ω))
