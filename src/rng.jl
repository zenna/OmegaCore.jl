using Random: AbstractRNG

rng(t) = t.tags.rng
hasrng(ω) = hastag(ω, Val{:rng})
tagrng(ω, rng::AbstractRNG) = tag(ω, (rng = rng,))
