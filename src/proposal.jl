module Proposal
using Distributions

export propose

# In general, a proposal is a function `q: Ω × Ω → Ω`
# That is, q(qω, ω) = ω' maps a current ω to ω'
# The additional input qω is necessary because proposals are not functions
# They are conditional distributions, qω is to capture the uncertainty
# in the proposal

# Most inference methods require that we can do two things with `q`, in general:
# The ability to construct samples, i.e. draw from q(ω' \mid ω)
# The ability to compute the (log) density / mass of q(ω' \mid ω)

# Here, we'll commit to a little more structure concerning `q`
# In particular, we'll define `q` through two things:
# (i) The random variable `x` that `ω` is defined on, and from which we ultimately which to sample
# (ii) A collection of subproposals `q_1, q_2, ... q_n` 

# A subproposal is a function `k :  Ω × Ω → Ω` with the same signature as `q`
# The difference is that with respect to the random variabel `x`, subproposals incomplete
# This means.

# Q. What's the interface

## The general approach here is:
## Assume as given some random variable `f` and some initial ω
## The initial ω may have some random variables that we wish to remain fixed
## Or it may be empty
## Execute the random variable `f`  and periodically fill in values of ω
## Our proposals are of the form:
## Given some preconditions (on ω) make some change to ω
## For example, suppose: x(ω) =   I have a normal distribution x = Normal(μ, σ)
## Given that `x`, μ, and σ are known then I may update the value of its StdNormal
## Alternatively given that I know

### If there's some primitive distribution within `f`

"A composite proposal defines by a set of sub proposals"
struct CompProposal{T <: Tuple}
  subproposals::T # This needs to be a dict from a set of 
end

# FIXME: Will this just break if I do it differently?
function stdpropose(qω, x::Member{<:StdUniform}, ω)
  # FIXME: This isn't quite right

  # FIXME: I'm not sure if we should be using qω here..?
  if x in keys(ω.data)
    nothing
  else
    # I don't think it should be the same uniform, it could be another d
    x_ = (1 ~ Normal(0, 1)(qω)
    # How should we make sure this doesn't clash with the original models
    # What about the logpdf
    # 
    x => x(qω)
  end
end

# FIXME: How to define proposal when composite?

# Should we have propose(qω, x, ω) = nothing

# Default caase, proposal isn't relevant to `x`
stdpropose(qω, x, ω) = nothing

# propose(T, x_, ω) = nothing

# "Make a proposal for random variable `f`"
# function propose!(f, ω)
#   @show ω.data
#   # FIXME: don't want to make proposal more than once do we?
#   for (x, x_) in ω.data
#     @show x, x_
#     proposal_ = propose(x, x_, ω)
#     if !isnothing(proposal_)
#       ω.data = merge(ω.data, proposal_)
#     end
#   end
#   ω
# end

function subproposals!(qω, f, ω, q::CompProposal)
  for subq in q.subproposals
    subω = subq(qω, f, ω)
    !isnothing(subω_) && ω = merge(subω)
  end
  ω
end

function Space.posthook(::trait(Proposeal), ret, f, ω::Ω)
  ## Add f to ω, since some proposal might depend on it
  if f in keys(ω.data)
    @assert ω.data[f] == ret # FIXME, this shouldn't be an assert,
    # Or should it?
  else
    ω.data[f] = ret
  end
  # @show f
  subproposals!(f, ω) # FIXME, need to get qω in here and subqs
end

"""
`propose(qω, f, ω)`

Generate proposal for random variables within `f`, returns ω::Ω

# Input
- `f`   Random variable.  Proposal will generate values for depenends of `f`
- `ω::Ω` Initial mapping, to condition variables add to here
- `qω::Ω` Randomness for proposal
# Returns
- `ω::Ω` mapping from random variables to values
"""
function propose(qω, f, ω, q::CompProposal)
  subproposals!(qω, f, ω)
  f(tagpropose(ω))
  ω
end

## Single - site MH proposal ##

"Single-site MH Proposal"
function ssmhpropose(qω, x::Member{<:StdUniform}, ω)
  # What's tricky about this?
  # Can we assume x is initialised?
  # Ok if so, ....

  # Randomly choose one of the values of ω
  # Tricky point 1, if we can move endogenous then inconsistencies can arise
  # saay we have
  μ = 1 ~ Normal(0, 1)
  x = 2 ~ Normal(μ, 1)
  # we have stdnormal 0 and std normal 1
  say x is conditioned and we have a value for μ and 1 and 2
  if we change μ, then its inconsistent with 1 and vice versa
  when we move only on exogenous we dont have this problem
  # we could overrite, but then there are order effets
  # so if some other variable depends on something which should be but isnt overwritten yet
  # ... troublesome! 

  # problem # 2 
end

function test()
  μ = 1 ~ Normal(0, 1)
  x(ω) = (2 ~ Normal(x(ω), 1))(ω)

  function subpropose1(qω, f, ω)
    # 1. Return new values, which are just merged, with null case being empty set
    # 2. Make it mutative, modify ω
    # 3. 
  end
  ω = defΩ()
  p = CompProposal(stdpropose,)
  ω_ = propose(rng, f, ω, cp)
end


end