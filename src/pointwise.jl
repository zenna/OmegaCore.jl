export pw, ==ₚ, l, dl

"""
Pointwise application.

Pointwise function application gives meaning to expressions such as `x + y`  when `x` and `y` are functions.
That is `x + y` is the function `ω -> x(ω) + y(ω)`.

Pointwise works when `x` is a function but `y` is a constant, and so on.

Principle:
if x(ω) is defined or y(ω) is defined and f(x, y) is not defined then
do pointwise application.

Is it safe to check whether a method exists?

```
using Distributions
x(ω) = Uniform(ω, 0, 1)
y = pw(+, x, 4)

f(ω) = Bool(Bernoulli(ω, 0.5)) ? sqrt : sin
sample(pw(map, f, [0, 1, 2]))
sample(pw(map, sqrt, [0, 1, 2]))
sample(pw(map, dl(sqrt), [0, 1, 2]))
sample(pw(l(f), 3))
```
"""
function pw end

abstract type ABox end

struct LiftBox{T} <: ABox
  val::T
end
"`l(x)` constructs object that indicates that `x` should be applied pointwise.  See `pw`"
l(x) = LiftBox(x)

struct DontLiftBox{T} <: ABox
  val::T
end
"`dl(x)` constructs object that indicates that `x` should be not applied pointwise.  See `pw`"
dl(x) = DontLiftBox(x)

# Trait functions
struct Lift end
struct DontLift end

traitlift(::Type{T}) where T  = DontLift()
traitlift(::Type{<:Function}) = Lift()
traitlift(::Type{<:DataType}) = DontLift()
traitlift(::Type{<:LiftBox}) = Lift()
traitlift(::Type{<:DontLiftBox}) = DontLift()

@inline constapply(f::T, ω) where T = constapply(traitlift(T), f, ω)
@inline constapply(::DontLift, f, ω) = f
@inline constapply(::DontLift, f::ABox, ω) = f.val
@inline constapply(::Lift, f, ω) = f(ω)
@inline constapply(::Lift, f::ABox, ω) = (f.val)(ω)
@inline constapply(::Lift, f::ABox, ω::ABox) = (f.val)(ω.val)
@inline constapply(::Lift, f, ω::ABox) = f(ω.val)
@inline pw(f, x) = ω -> f(constapply(x, ω))

@inline pw(f, x1, x2) = ω -> f(constapply(x1, ω), constapply(x2, ω))
@inline pw(f, x1, x2, x3) = ω -> f(constapply(x1, ω), constapply(x2, ω), constapply(x1, ω), constapply(x3, ω))
@inline pw(f, x1, args...) = ω -> f(constapply(x1, ω), (constapply(x, ω) for x in args)...)

@inline pw(f::LiftBox, x1, x2) = ω -> (constapply(f, ω))(constapply(x1, ω), constapply(x2, ω))
@inline pw(f::LiftBox, x1, x2, x3) = ω -> (constapply(f, ω))(constapply(x1, ω), constapply(x2, ω), constapply(x1, ω), constapply(x3, ω))
@inline pw(f::LiftBox, x1, args...) = ω -> (constapply(f, ω))(constapply(x1, ω), (constapply(x, ω) for x in args)...)


export ==ₚ, >=ₚ, <=ₚ
@inline x ==ₚ y = pw(==, x, y)
@inline x >=ₚ y = pw(>>, x, y)
@inline x <=ₚ y = pw(<=, x, y)