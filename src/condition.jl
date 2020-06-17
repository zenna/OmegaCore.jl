module Condition

using ..Space, ..Tagging, ..Traits
export |ᶜ, cond, conditions, cond!

# # Conditioning
# Conditioning a variable restricts the output to be consistent with some proposition.

"`x` given `y` is true"
struct Conditional{X, Y}
  x::X
  y::Y
end

@inline x |ᶜ y = cond(x, y)
@inline cond(x, y) = Conditional(x, y)

"Conditions variable was conditioned on are not satisfied"
struct ConditionException <: Exception end

@inline condf(traits, ω, x, y) = Bool(y(ω)) ? x(ω) : throw(ConditionException())

@inline condf(ω::Ω, x, y) where Ω = condf(traits(Ω), ω, x, y)

# If error are violated then throw error
@inline (c::Conditional)(ω) = condf(ω, c.x, c.y)

"Conditions on `xy`"
conditions(xy::Conditional) = xy.y
# Implement x(\omega) when x is conditioned
# Imolement logpdf when `x` is conditioned

"""
`cond!(ω::Ω, bool)`

Condition intermediate values from within the functional definition of a `RandVar`

```
function x_(ω)
  x = 0.0
  xs = Float64[]
  while bernoulli(ω, 0.8, Bool)
    x += uniform(ω, -5.0, 5.0)
    cond!(ω, x <=ₛ 1.0)
    cond!(ω, x >=ₛ -1.0)
    push!(xs, x)
  end
  xs
end

x = ciid(x_)
samples = rand(x, 100; alg = SSMH)
```
"""
cond!(ω::Ω, bool) where Ω = cond!(traits(Ω), ω, bool)
@inline cond!(traits, ω, bool) = nothing

# should thsi be cond!, it does have side effects, but it doesn't really modify its arguments
# it's not hte same thing as cond for sure
# It's more like an assertion

end