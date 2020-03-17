import Distributions: logpdf

# # Log pdf
# The Log pdf of a trace is important for conditioning and inference

"Logdensity of `rv` on input `ω`"
function logpdf(rv, ω)
  # FIXME: Don't double count
  tω = Tagged(ω, (logpdf = Box(0.0), seen = Set{ID}()))
  rv(tω)  
  tω.tag.logpdf.val
end

function handle_logpdf(T::Type{<:Distribution}, ret, ω, args...)
  # Preconditions: \omega is tagged with lopdf and seen
  if tωπ.val.id ∉ tωπ.tag.seen
    tωπ.tag.logpdf.val += logpdf(T(args...), ret)
    push!(tωπ.tag.seen, tωπ.val.id)
  end
  ret
end