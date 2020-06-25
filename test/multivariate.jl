using OmegaCore
using OmegaTest
using Distributions
using Test

@testset "multivariate" begin
  μ = 5
  xs = 1 ~ Mv(Normal(5, 1), (1000,))
  samples = randsample(xs)
  @test mean(samples) ≈ μ atol = 0.3
  @test isinferred(randsample, xs)
end