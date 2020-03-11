using Random: AbstractRNG, GLOBAL_RNG

# # Variable
# A random variable is a function from a sample space.
# In julia terms it is any function where `f(ω::T) where {T <: AbstractΩ}` is defined`


# # Sampling

sample(rng::AbstractRNG, f) = f(sample(rng, defΩ(f)))
sample(f) = sample(GLOBAL_RNG, f)

# # Conditional Independence
# It is useful to create independent and conditionally independent random variables
# This has meaning for both random and free variables

"""Conditionally independent copy of `f`

if `g = ciid(f, id)` then `g` will be:
"""
@inline ciid(f, id) = ω -> f(appendscope(ω, id))

"Alias for `ciid(f, i)`"
~(id, f) = ciid(f, id)

# FIXME: Give this a different syntax
~(f) = ω -> f(rmscope(ω))

appendscope(ω, id::ID) = tag(ω, (scope = ID,))
rmscope(ω::Tagged) = rmkeys(ω, :scope)

