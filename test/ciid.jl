using OmegaCore
using Test
using Distributions

function samplemodel()
  x = 1 ~ Normal(0, 1)
  y = 2 ~ Normal(0, 1)
  z(ω) = (x(ω), y(ω), x(ω))
  randsample(z)
end

function test_ciid()
  @test isinferred(samplemodel)
  z_ = samplemodel()
  @test z_[1] != z_[2]
  @test z_[1] == z_[3]
end

function test_shared_parent()
  parent = 1 ~ ω -> Bool(Bernoulli(0.5)(ω)) ? -100 : 100
  x(ω) = (~parent)(ω) + Uniform(0, 1)(ω)
  x1 = 2 ~ x
  x2 = 3 ~ x
  z = ω -> (x1(ω), x2(ω))
  samples = [randsample(z) for i = 1:10]
  t1 = [(x1_ != x2_) for (x1_, x2_) in samples]
  t2 = [(abs(x1_ - x2_) <= 2) for (x1_, x2_) in samples]
  @test all(t1)
  @test all(t2)
end

function double_scope()
  x = 1 ~ Normal(0, 1)
  y = 2 ~ x
  randsample((x, y)ₚ)
end

@testset "ciid" begin
  test_ciid()
  test_shared_parent()
end