module Solution

using Random
using Distributions
using ..Space, ..RNG, ..Tagging, ..Var, ..Traits
using ..Condition: Conditional
export solution

"""
`solution(x)`
Solution (aka model, interpretation) to constraints on random variable.

Returns any `ω` such that `x(ω) != ⊥`
"""
function solution end

const ConstTypes = Union{Real, Array{<:Real}}
const EqualityCondition{A, B} = BinaryPointwise{typeof(==), A, B} where {A, B <: ConstTypes}

tagcondition(ω, condition) = tag(ω, (condition = condition,))

# "If output of `o` is `val` what must its noise parameter must have been?`"
invert(o::Normal, val) = (val / o.σ) - o.μ

"""
```
μ = 1 ~ Normal(0, 1)
y = 2 ~ Normal(μ, 1)
μc = μ |ᶜ (y ==ₚ 5.0)
solution(μc)
```
"""
function solution(rng::AbstractRNG,
                  f::Conditional{X, Y},
                  Ω = defΩ()) where {X, Y <: EqualityCondition}
  ω = tagrng(Ω(), rng)
  ωc = tagcondition(ω, f.y)
  f(ωc)
  ω
end

idof(m::Member) = m.id
idof(v::Variable) = v.f.id

function Var.go(::trait(Cond), d::Normal, id, ω)
  # id is the id of this normal
  # if the id of the conditioned variable matches
  # then replace
  # well not just the id but the id and the function
  matches = idof(ω.tags.condition.a) == id
  # @show ω.tags.condition
  # @show traits(ω)

  # @assert false
  ## Update ω with appropraite value
  if matches
    inv = invert(d, ω.tags.condition.b)
    ω[id] = inv
  end
    # @assert false
  # else
    Var.go(nothing, d, id, ω)
end

solution(f::Conditional, Ω = defΩ()) =
  solution(Random.GLOBAL_RNG, f, Ω)



end


## What's wrong
# We need to indicate that a value does not need to be modified for conditioning
# I'm not 100 percent confident in the way im checking (id matching)
# this g(nothing) seems smelly
# What if we have more than one condition??
# Can we distinguish from X == X to X == Const at type level?
# how are we actually goign to do it !
# what more do we need for MH
