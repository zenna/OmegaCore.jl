export BinaryPointwise, ==ₚ
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