
using Random:AbstractRNG

# # Random number generator
rng(t::Tagged) = t.tags.rng
hasrng(::Type{T}) where {T <: Tagged} = hastag(T, Val{:rmg})
tagrng(ω, rng::AbstractRNG) = tag(ω, (rng = rng,))
