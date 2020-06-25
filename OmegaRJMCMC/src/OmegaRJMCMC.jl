"Reversible Jump MCMC"
module OmegaRJMCMC

# Reversible Jump MCMC is an MCMC method designed for methods with a variable number of parameters.
# This could be when we have a space of different models and a discrete random variable that indiciate into it.
# Or it could be when we have choices in our model which lead to more or fewer other random variables being instantiated.

"""

# Arguments
- `rng`: AbstractRng used to sample proposals in MH loop
- `moves`: set of moves
- `logdensity`: Density to sample from
- `n`: number of samples
"""
function rjmcmc(rng, )
  for sweep in nsweeps
    
end

greet() = print("Hello World!")

end # module
