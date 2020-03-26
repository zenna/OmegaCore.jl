import Distributions: logpdf, Distribution

"Logdensity of `f` on trace `ω`"
function logpdf(f, ω, ID::Type{T} = TupleID) where T
  tω = tag(ω, (logpdf = Box(0.0), seen = Set{ID}()))
  f(tω)  
  tω.tags.logpdf.val
end

# Traits
struct HasLogPdf end
struct NotHasLogPdf end

traithaslogpdf(::Type{<:Distribution}) = HasLogPdf()
traithaslogpdf(_) = NotHasLogPdf()
handle_logpdf(ret, f::FT, ω::ΩT) where {FT, ΩT} =
  handle_logpdf(traithastag(ΩT, Val{:logpdf}), traithaslogpdf(FT), ret, f, ω)

function handle_logpdf(::HasTag{:logpdf}, ::HasLogPdf, ret, f, ω)
  if scope(ω) ∉ ω.tags.seen
    ω.tags.logpdf.val += logpdf(f, ret)
    push!(ω.tags.seen, scope(ω))
  end
  ret
end

handle_logpdf(_, _, ret, f, ω) = ret