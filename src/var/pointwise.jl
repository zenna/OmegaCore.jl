export BinaryPointwise, ==ₚ
using Distributions: Distribution

# # Equality Condition
# Many (but not all) inference problems are of the form `X = x` where `X` is a
# a random variable abd `x` is a concrete constant.  Problems in this form often
# permit more tractable inference.  To exploit this we use a new type EqualityCondition
# so that we can identify theses cases just from their types

"ω -> f(a(ω), b(ω))"
struct BinaryPointwise{F, A, B}
  f::F
  a::A
  b::B
end

Base.show(io::IO, bp::BinaryPointwise) = print(io, bp.a, " $(bp.f)ₚ ", bp.b)
x ==ₚ y = BinaryPointwise(==, x, y)

const DontLift = Union{Number}
@inline apl(f, ω) = f(ω)
@inline apl(f::DontLift, ω) = f

# @inline (bp::BinaryPointwise)(ω) = bp.f(apl(bp.a, ω), apl(bp.b, ω))
@inline (bp::BinaryPointwise)(ω) = bp.f(@show(apl(bp.a, ω)), @show(apl(bp.b, ω)))

# struct Pointwise{D, PARAMS}
#   x::D
#   params::PARAMS
# end

# # # Todo, specialise this to 1,2,3,4,5 arguments
# (m::Pointwise)(ω) = m.x((liftapply(p, ω) for p in m.params)...)(ω)  
# (x::Type{<:Distribution})(params...) = Pointwise(x, params)
# Base.show(io::IO, pw::Pointwise) = "$(pw.x)ₚ $(pw.params)"

