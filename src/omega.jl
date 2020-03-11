using Distributions: Distribution
import Distributions: logpdf

# # Sample Space / Trace

"Sample space object"
struct Ω{T}
  data::T
end

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

"Logdensity of `rv` on input `ω`"
function logpdf(rv, ω)
  # FIXME: Don't double count
  tω = Tagged(ω, (logpdf = Box(0.0), seen = Set{ID}()))
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

