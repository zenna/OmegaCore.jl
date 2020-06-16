using OmegaCore
using Test
using Spec

# rmkeymthd = methods(rmkey).ms[1]
# rmkeymthd_preconds = preconds(rmkeymthd)
# naive_gen = rng -> rand(rng, NamedTuple)
# naive_gen |ᶜ rmkeymthd_preconds
# spectest(rmkey, rng -> rand(rng, NamedTuple)

@testset begin
  x = (a = 3, b = 4, c = 12)
  x_ = rmkey(x, :a)
  @test :b ∈ x_
  @test :c ∈ x_
  @test :a ∉ x_
end

macr

@spec "valid-keys" all([k ∈ keys(ret) for  k in keys(nt)])

function postmeta(::typeof(rmkey), ret, nt::NamedTuple{K, V}, key::Type{Val{T}}) where {K, V, T}
  (name = "valid-keys", check = true, )
end

function postcondition(::typeof(rmkey), ret, nt::NamedTuple{K, V}, key::Type{Val{T}}) where {K, V, T}

end