import OmegaCore
export MH, mh

"Metropolis Hastings Samplng Algorithm"
struct MHAlg end
const MH = MHAlg()

"""
Metropolis Hastings Sampler

`mh(rng, ΩT, logdensity, n; proposal, ωinit)`

Starting from `ωinit` produce `n` samples using Metropolis Hastings algorithm

# Arguments
- rng: AbstractRng used to sample proposals in MH loop
- `ΩT`:
- `n`: number of samples
- `logdensity`:  Density that mh will sample from.  Function of ω.
- `proposal`: a proposal distributioion. Has the form:
  `(ω_, log_p_q) = proposal(rng, ω)` where:
    `ω_` is the proposal
    `log_pqqp` is `log(g(p|q)/g(q|p))` the transition probability of moving from q to p
- `ωinit`: point initialised from
"""
function mh(rng,
            ΩT::Type{OT},
            logdensity,
            n;
            proposal = moveproposal,
            ωinit = ΩT()) where OT # should this be sat(f)
  ω = ωinit
  plast = logdensity(ω)
  qlast = 1.0
  ωsamples = OT[]
  accepted = 0
  # zt: what about burn-in
  for i = 1:n
    # ω_, logtransitionp = isempty(ω) ? (ω,0) : proposal(rng, ω)
    ω_, logtransitionp = proposal(rng, ω)
    p_ = logdensity(ω_)
    ratio = p_ - plast + logtransitionp # zt: assumes symmetric?
    if log(rand(rng)) < ratio
      ω = ω_
      plast = p_
      accepted += 1
    end
    push!(ωsamples, deepcopy(ω))
  end
  ωsamples
end

function OmegaCore.randsample(rng,
                       ΩT::Type{OT},
                       x,
                       n,
                       alg::MHAlg) where {OT}
end

OmegaCore.randsample(rng, ΩT, x, n, ::MHAlg; kwargs...) = 
  mh(rng, ΩT, condvar(x), n; kwargs...)