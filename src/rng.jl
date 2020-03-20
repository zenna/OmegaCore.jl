using Random: AbstractRNG

rng(t) = t.tags.rng
hasrng(t::T) where T = hastag(T, Val{:rng})
tagrng(ω, rng::AbstractRNG) = tag(ω, (rng = rng,))
