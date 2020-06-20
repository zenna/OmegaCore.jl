module Solution

using Random
using ..Space, ..RNG
using ..Condition: BinaryPointwise, Conditional
export solution

"""
`solution(x)`
Solution (aka model, interpretation) to constraints on random variable.

Returns any `ω` such that `x(ω) != ⊥`
"""
function solution end

const ConstTypes = Union{Real, Array{<:Real}}
const EqualityCondition{A, B} = BinaryPointwise{typeof(==), A, B} where {A, B <: ConstTypes}

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
  f(ω)
end

solution(f::Conditional, Ω = defΩ()) =
  solution(Random.GLOBAL_RNG, f, Ω)

end


## What's wrong
# What if we have more than one condition??
# Can we distinguish from X == X to X == Const at type level?
# how are we actually goign to do it !
# what more do we need for MH