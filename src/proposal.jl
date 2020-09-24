module Proposal
using Distributions

export propose

function propose!(x::StdUnif, ω)
  if x ∉ keys(ω.data)
    ω.data[x] = rand()
  end
end

propose(T, x_, ω) = nothing

"Make a proposal for random variable `f`"
function propose!(f, ω)
  @show ω.data
  # FIXME: don't want to make proposal more than once do we?
  for (x, x_) in ω.data
    @show x, x_
    proposal_ = propose(x, x_, ω)
    if !isnothing(proposal_)
      ω.data = merge(ω.data, proposal_)
    end
  end
  ω
end

## Where am I making these proposals?

Cassette.@context ProposalCtx
function Cassette.posthook(::trait(Proposeal), ret, f, ω::Ω)
  ## Add f to ω, since some proposal might depend on it
  if f in keys(ω.data)
    @assert ω.data[f] == ret
  else
    ω.data[f] = ret
  end
  @show f
  propose!(f, ω)
end

function Space.prehook(::trait(Proposeal), f::StdUnif, ω::Ω)
  propose!(f, ω)
end

"""
Generate proposal for random variables within `f`, returns ω::Ω
# Input
- `f`   Random variable.  Proposal will generate values for depenends of `f`
- `ω` Initial mapping, to condition variables add to here
# Returns
- `ω::Ω` mapping from random variables ot values
"""
propose(f, ω) = (f(tagpropose(ω)); ω)

end