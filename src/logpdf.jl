module Proposals
using Distributions: Distributions. logpdf
using Random: AbstractRNG

using ..Tag, ..Rng

"""
`proposal(x)`

# Returns
- `(ω = ω_, proposalenergy = proposalenergy_)` named tuple
"""
function propose end

@inline taglogpdf(ω, logpdf_, see) = 
  tag(ω, (logpdf = Box(0.0), seen = seen))

function propose(rng::AbstractRNG, x, ID::Type{T} = defID(), Ω = defΩ())
  ω = tagrng(Ω(), rng)
  ω = taglogpdf(ω, Box(0.0), Set{ID}())
  ## F
  ## when you encounter a conditioned variable
  #3 Update its base
  ## Update logpdf
end

function Var.posthook(::trait(Cond), ret, f::Distribution, ω)
  ω.tags.logpdf.val += logpdf(f, ret)
  if scope(ω) ∉ ω.tags.seen
    ω.tags.logpdf.val += logpdf(f, ret)
    push!(ω.tags.seen, scope(ω))
  end
  ret
end

## Probs
# id or without id
# avoid duplicats, need seen
# generalize to anything with a logpdf

end