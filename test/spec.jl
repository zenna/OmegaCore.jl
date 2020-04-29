module Spec

export post, pre

using Cassette

Cassette.@context SpecCtx

# 1. Capture variables
# 2. what if undefiend
# 3. multiple tests
# Disallow it, 
# Use global state (ew, icky!)
# invoke all
# 4. Sample arguments

@inline function Cassette.posthook(ctx::SpecCtx, ret, f, args...)
  meta = postmeta(f, ret, args...)
  if hasmeta(meta)
    @test post(f, ret, args...)
  end
end

"No post condition defined"
struct NoPost end

"A postcondition"
post(args...) = NoPost()

"""
Run tests on sampler.

f(x) = abs(x)
@post f(ret, x) = x > 0
@post f(ret, x) = typeof(x) == typeof(0)

spectest(f, 0.3)

"""
spectest(f, args...) = overdub(SpecCtx(), f, args...)


function sampletype(rng, ::Type{T}) where {T <: Tuple}
  T isa UnionAll && error("UnionAll not implemented")
  tuple((sampletype(rng, type) for type in T.parameters[2:end])...)
end

"Sample arguments for method `mthd`"
sampletype(rng, mthd::Method)  = sampletype(rng, mthd.sig)

# Default samplers

# sampletype(rng, ::Type{Symbol}) = 
# sampletype(rng, ::Type{<:NamedTuple{K, V}}) where {K, V} = sample(rng, NamedTuple{K, V}) 
# sampletype(rng, ::Type{<:NamedTuple}) = sampletype(rng, NamedTuple{K, V}) 

struct IsAbstract end
struct NotIsAbstract end
struct IsConcrete end
struct NotIsConcrete end

sampletype(rng, ::Type{T <:Number}) where {T <:Number} = rand(rng, T)

traitisabstract(::Type{T}) where T = isabstracttype(T) ? IsAbstract() : NotIsAbstract()
traitisconcrete(::Type{T}) where T = isconcretetype(T) ? IsConcrete() : IsConcrete()

sampletype(rng, ::Type{Union{T}}) where T = sampletype(rng, (T.a, T.b))

sampletype(rng, ::Type{Complex{T}}) where T = Complex(sampletype(T), sampletype(T))

sampletype(rng, ::IsAbstract, _, T) = sampletype(rng, subtypes(T))
sampletype(rng, ::IsAbstract, _, T) = sampletype(rng, subtypes(T))

sampletype(rng, ::Type{T}) where T = sampletype(rng, traitisabstract(T), traitisconcrete(T))


sampletype(x) = sampletype(Random.GLOBAL_RNG, x)

end