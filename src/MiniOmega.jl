module MiniOmega

import Statistics:mean

export rv, cond, Ω, bernoulli, prob, doo

# Please note that since Julia is eager, this implementation differs from our semantics

# The Ω type is a mapping from pairs of indices (i, j) to random values in [0, 1]
# in an index (i, j) different i are for different random variables and
# different j are for different random variables within a random variable

"Sample Space Object"
mutable struct Ω
  data::Dict{Int, Real}
  # i::Int
end

mutable struct IntervenedΩ
  data::Dict{Int, Real}
  intervention::Pair
end

"ω[j] returns jth value, under whatever random variable it is currently projected to"
function Base.getindex(ω::Union{Ω, IntervenedΩ}, j)
  if j in keys(ω.data)
    ω.data[j]
  else
    val = rand()
    ω.data[j] = val
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

# distributions section
function bernoulli(p::Real, idx::Int)
  return ω -> ω[idx] >= p
end

"Turn a function `f` into a random variable by giving it a unique id"
rv(f) = (global counter += 1; RandVar(counter, f))

# "Project `ω` to the subspace of `rv`"
# proj(ω::Ω, rv::RandVar) = Ω(ω.data, rv.id)

"Random variable application first projects `ω` to `rv` then applies function"
(rv::RandVar)(ω::Ω) = rv.f(ω)

function (rv::RandVar)(ω::IntervenedΩ)
  if rv == ω.intervention[1]
    ω.intervention[2]
  else
    rv.f(ω)
  end
end

"Conditoning evaluates an error if `y` is `false`"
cond(x::RandVar, y::RandVar) = rv(ω -> y(ω) ? x(ω) : error())

"do operator"
function doo(x::RandVar, intervention)
  rv(ω -> x(IntervenedΩ(ω.data, intervention)))
end

"Rejection Sampling: keeps trying until now errors thrown"
Base.rand(x::RandVar) = try x(Ω(Dict())) catch; rand(x) end

"Return prob that rv is true"
function prob(x::RandVar, n::Int=1000)
  samples = [rand(x) for i=1:n]
  mean(samples)
end

# override logical 'OR' operator for rvs
Base.:|(x::RandVar, y::RandVar) = rv((ω -> x(ω) | y(ω)))

# override negation operator for rvs, only for true/false rvs
Base.:!(x::RandVar) = rv(ω -> !x(ω))

end # module