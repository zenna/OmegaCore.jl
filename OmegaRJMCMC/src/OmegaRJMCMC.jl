"Reversible Jump MCMC"
module OmegaRJMCMC

export rjmcmc, RJMCMC

struct RJMCMCAlg end
const RJMCMC = RJMCMCAlg()

# Reversible Jump MCMC is an MCMC method designed for methods with a variable number of parameters.
# This could be when we have a space of different models and a discrete random variable that indiciate into it.
# Or it could be when we have choices in our model which lead to more or fewer other random variables being instantiated.

"""
# Arguments
- `rng`: AbstractRng used to sample proposals in MH loop
- `moves`: set of moves
- `logdensity`: Density to sample from
- `n`: number of samples  

# Returns
- 'xs': set of samples

```

```
"""
function rjmcmc(rng, x, moves, logdensity, n)
  # TODO accept jacobian
  xs = [x]

  # Sample a moveset
  m = move(rng, x) # TODO: THis is invalid
  for i = 1:n
    (x_, u_) = m(x)    
    ℓratio = ℓ(x') / ℓ(x)
    jratio = j(m, x)
    if rand(rng, Bernoulli(accept_ratio))
      x = x'
    end
    push!(xs, x)
  end
  xs
end

function OmegaCore.randsample(rng,
                              ΩT::Type{OT},
                              x,
                              n,
                              alg::RJMCMCAlg) where {OT}
  # introduce conditions
  # y = OC.mem(OC.indomain(x))
  y = condvar(x)
  ωsamples = OC.condomegasample(rng, ΩT, y, n, alg)
  # map(OC.mem(x), ωsamples)
  map(x, ωsamples)
end

end
