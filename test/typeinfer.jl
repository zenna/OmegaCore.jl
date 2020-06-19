using OmegaCore
using Test
using Distributions
using Random
using OmegaCore.Traits

# function testscope()
#   ω1 = SimpleΩ(Dict([1, 1] => 0.1234, [1,] => 0.1234))
#   ω2 = OmegaCore.appendscope(ω1, [1,])
#   ω3 = OmegaCore.appendscope(ω2, [3,])
#   traits_ = traits(ω2)
# end

# g(::Type{T}) where {T >: OmegaCore.Scope} = 3
# g(::Type{T}) where {T} = 3.0

function testtraits()
  ω = SimpleΩ(Dict())
  ω2 = OmegaCore.appendscope(ω, [1,])
  # traits(typeof(ω2.tags))
  g(traits(typeof(ω2)))
end


function testsimple1()
  ω = defΩ()()
  ω = OmegaCore.tagrng(ω, Random.GLOBAL_RNG)
  ω2 = defΩ()()
  ω2 = OmegaCore.tagrng(ω2, Random.GLOBAL_RNG)
  x = 1 ~ Normal(0, 1)
  map(x, [ω, ω2])
end

function testsimple2()
  x = 1 ~ Normal(0, 1)
  rng = Random.GLOBAL_RNG
  ΩT = defΩ()
  y = OmegaCore.condvar(x)
  ω =  OmegaCore.OmegaRejectionSample.condomegasample1(rng, ΩT, y, OmegaCore.RejectionSample)
  x(ω)
end

function testsimple3a()
  x = 1 ~ Normal(0, 1)
  rng = Random.GLOBAL_RNG
  ΩT = defΩ()
  y = OmegaCore.condvar(x)
  ω =  OmegaCore.OmegaRejectionSample.condomegasample1(rng, ΩT, y, OmegaCore.RejectionSample)
  map(x, typeof(ω)[ω, ω])
end

function testsimple3()
  x = 1 ~ Normal(0, 1)
  rng = Random.GLOBAL_RNG
  ΩT = defΩ()
  y = OmegaCore.condvar(x)
  ω =  OmegaCore.OmegaRejectionSample.condomegasample1(rng, ΩT, y, OmegaCore.RejectionSample)
  x.([ω, ω])
end

function testsimple4()
  x = 1 ~ Normal(0, 1)
  rng = Random.GLOBAL_RNG
  ΩT = defΩ()
  y = OmegaCore.condvar(x)
  ω =  OmegaCore.OmegaRejectionSample.condomegasample(rng, ΩT, y, 5, OmegaCore.RejectionSample)
  map(x, ω)
end

function testsimple5()
  x = [1] ~ Normal(0, 1)
  ω1 = SimpleΩ(Dict([1, 1] => 0.1234, [1,] => 0.1234))
  ω2 = OmegaCore.appendscope(ω1, [1,])
  ωs = [ω2,ω2]
  x.f
  # xs1 = map(x.f, ωs)
  xs2 = map(w -> OmegaCore.recurse(x.f.f, w), ωs)
end

function testsimple6()
  x = [1] ~ Normal(0, 1)
  ω1 = SimpleΩ(Dict([1, 1] => 0.1234, [1,] => 0.1234))
  ω2 = OmegaCore.appendscope(ω1, [1,])
  ωs = [ω2,ω2]
  x.f
  xs1 = map(x.f, ωs)
  # xs2 = map(w -> OmegaCore.recurse(x.f, w), ωs)
end


@testset "infer types" begin
  @test isinferred(testsimple1)
  @test isinferred(testsimple2)
  @test isinferred(testsimple3)
  @test isinferred(testsimple3a)
  @test isinferred(testsimple4)
  @test isinferred(testsimple5)
end  