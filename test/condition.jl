using OmegaCore, Distributions
using Test
import Random

"Test conditioning on predicate of positive measure"
function test_pos_measure()
  rng = Random.MersenneTwister(0)
  x = 1 ~ Normal(0, 1)
  y(ω) = x(ω) > 0
  x_cond = x |ᶜ y
  samples = randsample(rng, x_cond, 100000; alg = RejectionSample)
  samplemean = mean(samples)
  exactmean = mean(truncated(Normal(0, 1), 0, Inf))
  @test samplemean ≈ exactmean atol = 0.01
end

"Test whether the logpdf is correct"
function test_density_cond()
  rng = Random.MersenneTwister(0)
  μ = 1 ~ Normal(0, 1)
  x = Normal(μ, 1.0)

  μ_ = -0.4321
  x_ = 0.1234
  μₓ = μ |ᶜ (x ==ₚ x_)
  ω = SimpleΩ(Dict((1,) => μ_))
  logpdf_ = logpdf(Normal(0, 1), μ_) + logpdf(Normal(μ_, 1), x_)
  @test logpdf(μₓ, ω) == logpdf_
end

function test_out_of_order_condition()
  x = 1 ~ Poisson(1.3)
  function f(ω)
    n = x(ω)
    x = 0.0
    for i = 1:n
      x += (i + 1) ~ Normal(0, 1)(ω)
    end
    x
  end

  f_ = f |ᶜ (x ==ₚ 3.0)
  g_ = ω -> (x(ω), f_(ω))
end

function test_parent()
  μ = 1 ~ Normal(0, 1)
  x = 2 ~ Normal(μ, 1)
  x_ = 0.123
  μ_ = 0.1
  μ |ᶜ x == x_
  ω = defΩ()((1,) => μ_)
  @test logpdf(μ_, ω) = logpdf(Normal(0, 1), μ_) + logpdf(Normal(μ_, 1), x_)
end

@testset "Conditions" begin
  test_pos_measure()
  test_out_of_order_condition()
  test_parent()
end

# We can use an intervention in this case
# In order to do the conditioning in eed to b eabel to replace the value
# as well as intercept the application
# I'll need some notion of equivalence
# 