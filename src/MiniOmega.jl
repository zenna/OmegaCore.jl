module MiniOmega

export rv, cond

# Please note that since Julia is eager, this implementation differs from our semantics

# The Ω type is a mapping from pairs of indices (i, j) to random values in [0, 1]
# in an index (i, j) different i are for different random variables and
# different j are for different random variables within a random variable

"Sample Space Object"
mutable struct Ω
  data::Dict{Tuple{Int, Int}, Real}
  i::Int
end

"ω[j] returns jth value, under whatever random variable it is currently projected to"
function Base.getindex(ω::Ω, j)
  if (ω.i, j) in keys(ω.data)
    ω.data[(ω.i, j)]
  else
    val = rand()
    ω.data[(ω.i, j)] = val
    val
  end
end

# A Random variable is a function defined on a projection (id) of the sample space

"A Random Variable"
struct RandVar
  id::Int
  f::Function
end

global counter = 0

"Turn a function `f` into a random variable by giving it a unique id"
rv(f) = (global counter += 1; RandVar(counter, f))

"Project `ω` to the subspace of `rv`"
proj(ω::Ω, rv::RandVar) = Ω(ω.data, rv.id)

"Random variable application first projects `ω` to `rv` then applies function"
(rv::RandVar)(ω::Ω) = rv.f(proj(ω, rv))

"Conditoning evaluates an error if `y` is `false`"
cond(x::RandVar, y::RandVar) = rv(ω -> y(ω) ? x(ω) : error())

"Rejection Sampling: keeps trying until now errors thrown"
Base.rand(x::RandVar) = try x(Ω(Dict(), 0)) catch; rand(x) end

end # module
