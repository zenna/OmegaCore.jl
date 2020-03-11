# # Log pdf
# The Log pdf of a trace is important for conditioning and inference

"Logdensity of `rv` on input `ω`"
function logpdf(rv, ω)
  # FIXME: Don't double count
  tω = Tagged(ω, (logpdf = Box(0.0), seen = Set{ID}()))
  rv(tω)  
  tω.tag.logpdf.val
end

function handle_logpdf(T::Type{<:Distribution}, ret, tωπ::Tagged{Proj{OM}}, args...) where {OM}
  # Preconditions: \omega is tagged with lopdf and seen
  ctx = tωπ.tag

  # Avoid double counting
  if tωπ.val.id ∉ ctx.seen
    ctx.logpdf.val += logpdf(T(args...), ret)
    push!(ctx.seen, tωπ.val.id)
  end
  ret
end

# Handle tags
function (T::Type{<:Distribution})(tωπ::Tagged{Proj{OM}}, args...) where {OM}
  ret = T(tωπ.val, args...)
  if hastag(tωπ, Val{:logpdf})
    handle_logpdf(T, ret, tωπ, args...)
  end
  ret
end
  