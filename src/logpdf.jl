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

# FIXME: check for tags  oo
traithaslogpdf(::Type{<:Distribution}) = HasLogPdf()
traithaslogpdf(_) = NotHasLogPdf()
handle_logpdf(ret, f, ω::T) where T = handle_logpdf(traithaslogpdf(T), ret, f, ω)

function handle_logpdf(::HasLogPdf, ret, f, ω)
  # Preconditions: \omega is tagged with lopdf and seen
  if scope(ω) ∉ ω.tags.seen
    ω.tags.logpdf.val += logpdf(f, ret)
    push!(ω.tags.seen, scope(ω))
  end
  ret
end

handle_logpdf(::NotHasLogPdf, ret, f, ω) = ret