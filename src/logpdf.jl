import Distributions: logpdf, Distribution

"Logdensity of `rv` on input `ω`"
function logpdf(rv, ω)
  # FIXME: Don't double count
  tω = tag(tω, (logpdf = Box(0.0), seen = Set{ID}()))
  rv(tω)  
  tω.tags.logpdf.val
end

# Traits
struct HasLogPdf end
struct NotHasLogPdf end

traithaslogpdf(::Type{<:Distribution}) = HasLogPdf()
traithaslogpdf(_) = NotHasLogPdf()
handle_logpdf(T, ret, ω, args...) = handle_logpdf(traithaslogpdf(T, ret, ω, args...))

function handle_logpdf(::HasLogPdf, T, ret, ω)
  # Preconditions: \omega is tagged with lopdf and seen
  if scope(ω) ∉ ω.tags.seen
    ω.tags.logpdf.val += logpdf(T, ret)
    push!(ω.tags.seen, scope(ω))
  end
  ret
end

