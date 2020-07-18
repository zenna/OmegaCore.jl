using OmegaCore, OmegaCore.Proposals
using OmegaTest
using Distributions
using Test

function test_logpdf_ucond()
  a = 1 ~ Normal(0, 1)
  b = 2 ~ Normal(2, 3)
  z(ω) = (a(ω), b(ω))
  ω, ℓ = propose(Random.GLOBAL_RNG, z)
  @test isinferred(propose, Random.GLOBAL_RNG, z)
  a_, b_ = z(ω)
  @test ℓ == logpdf(Normal(0, 1), a_) + logpdf(Normal(2, 3), b_)
end

# function test_logpdf()
#   μ = 1 ~ Normal(0, 1)
#   x = 2 ~ Normal(~μ, 1)
#   μ_ = 0.1234
#   x_ = -0.54321
#   ω = SimpleΩ(Dict((2,) => x_, (1,) => μ_))

#   p = logpdf((μ, x)ₚ, ω)
#   @inferred logpdf(Normal(0, 1), μ_) + logpdf(Normal(μ_, 1), x_)
#   @test p == logpdf_
# end

@testset "Logpdf" begin
  test_logpdf_ucond()
end

# struct MyDist
#   μ::Float64
#   σ::Float64
# end

# OmegaCore.logpdf(d::MyDist, ret, μ, σ) = exp(μ, σ)

# function f(ω)
#   x = Normal(0, 1)(ω)
#   y = Normal(0, 1)(ω)
#   z = sqrt(x + y) / 2.0
# end

# OmegaCore.logpdf(::typeof(f), x) = sqrt(x)