using Test
using OmegaCore
using Distributions

function test_model()
  # Normally distributed random variable with id 1
  x = 1 ~ Normal(0, 1)
  
  # Normally distributed random variable with id 2 and x as mean
  yy(ω) =  2 ~ Uniform(x, x(ω) + 1)
  y = 2 ~ yy
  x_ = 0.1
  y_ = 0.3

  # An omega object -- like a trace
  ω = SimpleΩ(Dict((1,) => x_, (2,) => y_))

  # model -- tuple-valued random variable ω -> (x(ω), y(ω)), becase we want joint pdf
  m = (x, y)ₚ
  (x, y, m)
end

function test_intervention()
  x, y, m = test_model()
  yⁱ = y |ᵈ (x => (3 ~ Constant(100.0)))
  @test 100.0 <= randsample(yⁱ) <= 101.0
  # @inferred randsample(yⁱ)
end

function test_intervene_diff_parents()
  x = 1 ~ Normal(0, 1)
  y = 2 ~ Normal(x, 1)
  x2 = 3 ~ x
  yⁱ = y |ᵈ (x => 100.0)
  yⁱ2 = y |ᵈ (x2 => 100.0)
  yⁱ_, yⁱ2_ = randsample((yⁱ, yⁱ2)ₚ)
  @test yⁱ_ != yⁱ2_
end

function test_intervention_logpdf()
  # Log density of model wrt ω
  l = logpdf(m, ω)

  # Check it is what it should be
  @test l == logpdf(Normal(0, 1), x_) + logpdf(Normal(x_, 1), y_)

  # Intervened model
  v_ = 100.0

  # y had x been v_
  yⁱ = y | had(x => v_)

  # new model with Intervened variables
  mⁱ = rt(x, yⁱ)

  # log pdf of interved model on same ω
  lⁱ = logpdf(mⁱ, ω)
  logpdf(x, ω)

  
  @test lⁱ == logpdf(Normal(0, 1), x_) + logpdf(Normal(v_, 1), y_)
  @test lⁱ < l
end

@testset "intervene" begin
  test_intervention()
  test_intervene_diff_parents()
  test_intervention_logpdf()
end 