using OmegaCore
using Distributions


μ = 5
xs = 1 ~ Mv(Normal(5, 10), (100,))
samples = randsample(xs)
@test mean(samples) == μ atol 0.2
@test randsample(xs)