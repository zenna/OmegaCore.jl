using Random: AbstractRNG, GLOBAL_RNG

# # Variable
# A random variable is a function from a sample space.
# In julia terms it is any function where `f(ω::T) where {T <: AbstractΩ}` is defined`

# # Sampling

sample(rng::AbstractRNG, f) = f(sample(rng, defΩ(f)))
sample(f) = sample(GLOBAL_RNG, f)

