module Proposals

"""
`proposal(x)`

# Returns
- `(ω = ω_, proposalenergy = proposalenergy_)` named tuple
"""
function proposal(x, ω)
end

function 


# import Distributions: logpdf, Distribution

# @inline taglogpdf(ω, logpdf_, see) = 
#   tag(ω, (logpdf = Box(0.0), seen = seen))

# "Logdensity of `f` on trace `ω`"
# function logpdf(f, ω, ID::Type{T} = defID()) where T
#   tω = taglogpdf(ω, Box(0.0), Set{ID}())
#   f(tω)  
#   tω.tags.logpdf.val
# end

# # Traits
# struct HasLogPdf end
# struct NotHasLogPdf end

# traithaslogpdf(::Type{<:Distribution}) = HasLogPdf()
# traithaslogpdf(_) = NotHasLogPdf()
# handle_logpdf(ret, f::FT, ω::ΩT) where {FT, ΩT} =
#   handle_logpdf(traithastag(ΩT, Val{:logpdf}), traithaslogpdf(FT), ret, f, ω)

# function handle_logpdf(::HasTag{:logpdf}, ::HasLogPdf, ret, f, ω)
#   if scope(ω) ∉ ω.tags.seen
#     ω.tags.logpdf.val += logpdf(f, ret)
#     push!(ω.tags.seen, scope(ω))
#   end
#   ret
# end

# handle_logpdf(_, _, ret, f, ω) = ret

# DataShould instead store

# id => Dist

# id => (Dist, Value)
# (id, Dist) => Value

# logpdf(ω::AbstractΩ) = 
#   reduce((l, r) -> logpdf(l) + r; init = 0.0)

end