# # Causal interventions
using ..Var
export |ᵈ, intervene


abstract type AbstractIntervention end

"The imperative that `x` should be replaced to value `v`"
struct Intervention{X, V} <: AbstractIntervention
  x::X
  v::V
end

# Intervention(x::Pair{Variable, <:Number}) = Intervention(x.first, ω -> x.second)
# Intervention(x::Pair) = Intervention(x.first, typeof(x.second) <: Number ? ω -> x.second : x.second)

Intervention(x::Pair) = Intervention((x...,))
Intervention(x::Tuple{Variable, <:Number}) = Intervention(x[1], ω -> x[2])
Intervention(x::Tuple) = Intervention(x[1], x[2])

"Multiple variables intervened"
struct MultiIntervention{XS} <: AbstractIntervention
  is::XS
end

"Intervened Variable: `x` had intervention `i` been the case"
struct Intervened{X, I}
  x::X
  i::I
end

"Merge Interventions"
mergeinterventions(i1::Intervention, i2::Intervention) = MultiIntervention((i1, i2))
mergeinterventions(i1::Intervention, i2::MultiIntervention) = MultiIntervention((i1, i2.is...))
mergeinterventions(i1::MultiIntervention, i2::Intervention) = MultiIntervention((i1.is..., i2))

"Merge Intervention Tags"
function mergetags(nt1::NamedTuple{K1, V1}, nt2::NamedTuple{K2, V2}) where {K1, K2, V1, V2}
  if K1 ∩ K2 == [:intervene]    
    ks = []
    values = [] 
    for (k,v) in zip(keys(nt1), nt1)
      if k != :intervene
        push!(ks, k)
        push!(values, v)
      end
    end

    for (k,v) in zip(keys(nt2), nt2)
      if k != :intervene
        push!(ks, k)
        push!(values, v)
      end
    end
    
    push!(ks, :intervene)
    push!(values, mergeinterventions(nt2[:intervene], nt1[:intervene]))

    NamedTuple{(ks...,)}(values)
  else
    Core.println(K1, " naa ", K2)
    @assert false "Unimplemented"
  end

end

"intervened"
intervene(x, intervention::Intervention) = Intervened(x, intervention)
intervene(x, intervention::Pair) = Intervened(x, Intervention(intervention))
intervene(x, interventions::Tuple) =
  Intervened(x, MultiIntervention(map(Intervention, interventions)))

@inline x |ᵈ i = intervene(x, i)