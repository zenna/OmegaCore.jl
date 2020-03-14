export |ᶜ, cond
# # Conditioning

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