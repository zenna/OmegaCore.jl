using OmegaCore
using Distributions
using Test

function test_logpdf()
  μ = 1 ~ Normal(0, 1)
  x = 2 ~ Normal(~μ, 1)
  μ_ = 0.1234
  x_ = -0.54321
  ω = SimpleΩ(Dict((2,) => x_, (1,) => μ_))

  p = logpdf((μ, x)ₚ, ω)
  @inferred logpdf_ = logpdf(Normal(0, 1), μ_) + logpdf(Normal(μ_, 1), x_)
  @test p == logpdf_
end

@testset "Logpdf" begin
  test_logpdf()
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