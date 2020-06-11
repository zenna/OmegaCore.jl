module Condition

using ..Space
export |ᶜ, cond, conditions

# # Conditioning
# Conditioning a variable restricts the output to be consistent with some proposition.

"`x` given `y` is true"
struct Conditional{X, Y}
  x::X
  y::Y
end

@inline x |ᶜ y = cond(x, y)
@inline cond(x, y) = Conditional(x, y)

"Thrown when conditions are violated"
struct ConditionException <: Exception end
(c::Conditional)(ω) = c.y(ω) ? c.x(ω) : throw(ConditionException())

# function (c::Condition{X, Y} where {Y <: PointWise{typeof(==), }})
#   # tricky because we want the log trace too
# end

function apply(f, x::AbstractΩ)

end

"Conditions on `xy`"
conditions(xy::Conditional) = xy.y
# Implement x(\omega) when x is conditioned
# Imolement logpdf when `x` is conditioned


function conditions(x)
  # Return a random variable that are the conditions `x` is conditioned on
  
end

end