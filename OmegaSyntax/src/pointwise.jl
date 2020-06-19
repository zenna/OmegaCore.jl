module Pointwise
using OmegaCore
export pw, ==ₚ, l, dl, ₚ
 
"""
Pointwise application.

Pointwise function application gives meaning to expressions such as `x + y`  when `x` and `y` are functions.
That is `x + y` is the function `ω -> x(ω) + y(ω)`.

An argument can be either __lifted__ or __not lifted__.
For example in `x = Normal(0, 1); y = pw(+, x, 3)`, `x` will be lifted but `3` will not be in the sense that
`y` will resolve to `ω -> x(ω) + 3` and not `ω -> x(ω) + 3(ω)`.

`pw` uses some reasonable defaults for what to lift and what not to lift, but to have more explicit control use `l` and `dl` to
lift and dont lift respectively.

Example:
```
using Distributions
x(ω) = Uniform(ω, 0, 1)
y = pw(+, x, 4)

f(ω) = Bool(Bernoulli(ω, 0.5)) ? sqrt : sin
sample(pw(map, f, [0, 1, 2]))
sample(pw(map, sqrt, [0, 1, 2])) # Will error!
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

# Traits
struct Lift end
struct DontLift end

# Trait functions
traitlift(::Type{T}) where T  = DontLift()
traitlift(::Type{<:Function}) = Lift()
traitlift(::Type{<:Variable}) = Lift()
traitlift(::Type{<:Scoped}) = Lift()
traitlift(::Type{<:DataType}) = DontLift()
traitlift(::Type{<:LiftBox}) = Lift()
traitlift(::Type{<:DontLiftBox}) = DontLift()

@inline liftapply(f::T, ω) where T = liftapply(traitlift(T), f, ω)
@inline liftapply(::DontLift, f, ω) = f
@inline liftapply(::DontLift, f::ABox, ω) = f.val
@inline liftapply(::Lift, f, ω) = f(ω)
@inline liftapply(::Lift, f::ABox, ω) = (f.val)(ω)
@inline liftapply(::Lift, f::ABox, ω::ABox) = (f.val)(ω.val)
@inline liftapply(::Lift, f, ω::ABox) = f(ω.val)
@inline pw(f, x) = ω -> f(liftapply(x, ω))

@inline pw(f, x1, x2) = ω -> f(liftapply(x1, ω), liftapply(x2, ω))
@inline pw(f, x1, x2, x3) = ω -> f(liftapply(x1, ω), liftapply(x2, ω), liftapply(x1, ω), liftapply(x3, ω))
@inline pw(f, x1, args...) = ω -> f(liftapply(x1, ω), (liftapply(x, ω) for x in args)...)

@inline pw(f::LiftBox, x1, x2) = ω -> (liftapply(f, ω))(liftapply(x1, ω), liftapply(x2, ω))
@inline pw(f::LiftBox, x1, x2, x3) = ω -> (liftapply(f, ω))(liftapply(x1, ω), liftapply(x2, ω), liftapply(x1, ω), liftapply(x3, ω))
@inline pw(f::LiftBox, x1, args...) = ω -> (liftapply(f, ω))(liftapply(x1, ω), (liftapply(x, ω) for x in args)...)

@inline pw(f) = args -> pw(f, args...)

export ==ₚ, >=ₚ, <=ₚ
@inline x ==ₚ y = pw(==, x, y)
@inline x >=ₚ y = pw(>>, x, y)
@inline x <=ₚ y = pw(<=, x, y)

# Collections
@inline randcollection(xs) = ω -> map(x -> liftapply(x, ω), xs)
struct LiftConst end
const ₚ = LiftConst()
Base.:*(xs, ::LiftConst) = randcollection(xs)

end