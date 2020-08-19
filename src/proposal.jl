module Proposal

using Distributions: Distribution
import ..Var

function proposal(d::Distribution, id, val, ω)
  # FIXME: Is this correct?
  # matches = idof(ω.tags.condition.a) == id
  # if matches
  #   ω[id] = (primdist(d), inv)
  # end
  # nothing
  inv = invert(d, val)
  primdist(d, id) => inv
end

"""Proposal values for other variables given value of `f`

# Returns
"""
proposal(f, val, ω) = nothing

function Var.prehook(traits, f, ω)
  proposl_ = proposal(f, ω)
  updateω!(ω, proposl_)
  # If I haven't already does this:
    # check if there is a proposal distribution for this variable
      # if there is then then apply it

  # FIXME: Is this correct?
  matches = idof(ω.tags.condition.a) == id
  if matches
    inv = invert(d, ω.tags.condition.b)
    ω[id] = (primdist(d), inv)
  end
end'


## Where to store dist values?
## condition / omega itself
## If we store in Omega then
## Omega needs to store non-primitives
  ## complicate logpdf? prolly not realy
  ## Currently structure of omega is prim rand var, id, val

end