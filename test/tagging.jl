using OmegaCore
using Test
using Random
using OmegaCore.Tagging

@testset "tagging" begin
  w = defΩ()()
  w = OmegaCore.RNG.tagrng(w, Random.MersenneTwister())
  w = OmegaCore.TrackError.tagerror(w, false)
  t_ = traits(w)
  @test t_ == Union{OmegaCore.Tagging.Err, OmegaCore.Tagging.Rng}
end

@testset "tagging2" begin
  w = defΩ()()
  w2 = OmegaCore.CIID.appendscope(w, 2)
  f(x::trait(OmegaCore.Tagging.Scope)) = 1
  f(_) = 2
  @test f(traits(w)) == 2
  @test f(traits(w2)) == 1
  @test @inferred f(traits(w))
  @test @inferred f(traits(w2))
end

@testset "tagging2" begin
  w = defΩ()()
  w2 = OmegaCore.CIID.appendscope(w, 2)
  f(x::trait(OmegaCore.Tagging.Scope, OmegaCore.Tagging.Rng)) = 1
  f(x::trait(OmegaCore.Tagging.Scope, OmegaCore.Tagging.Mem)) = 2
  @test_throws MethodError f(w2)
end

@testset "tagging2" begin
  w = defΩ()()
  w2 = OmegaCore.CIID.appendscope(w, 2)
  f(x::trait(OmegaCore.Tagging.Scope, OmegaCore.Tagging.Rng)) = 1
  f(x::trait(OmegaCore.Tagging.Scope, OmegaCore.Tagging.Mem)) = 2
  @test_throws MethodError f(traits(w2))
end

@testset "tagging" begin
  w = defΩ()()
  w = OmegaCore.RNG.tagrng(w, Random.MersenneTwister())
  w = OmegaCore.TrackError.tagerror(w, false)
  w = OmegaCore.CIID.appendscope(w, 2)
  g(x::trait(OmegaCore.Tagging.Rng)) = 1
  g(x::trait(OmegaCore.Tagging.Scope)) = 2
  @test_throws MethodError g(traits(w))
end
