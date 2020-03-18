export randsample
using Random: AbstractRNG, GLOBAL_RNG

# # Variable
# A random variable is a function from a sample space.
# In julia terms it is any function where `f(ω::T) where {T <: AbstractΩ}` is defined`

# # Sampling

randsample(rng::AbstractRNG, f) = f(randsample(rng, defΩ(f)))
randsample(f) = randsample(GLOBAL_RNG, f)

