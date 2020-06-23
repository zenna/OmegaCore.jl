# # Causal interventions
export |ᵈ, intervene

abstract type AbstractIntervention end

"The imperative that `x` should be replaced to value `v`"
struct Intervention{X, V} <: AbstractIntervention
  x::X
  v::V
end

Intervention(x::Pair) = Intervention(x.first, x.second)

"Multiple variables intervened"
struct MultiIntervention{XS} <: AbstractIntervention
  is::XS
end

"Intervened Variable: `x` had intervention `i` been the case"
struct Intervened{X, I}
  x::X
  i::I
end

"intervened"
intervene(x, intervention::Intervention) = Intervened(x, intervention)
intervene(x, intervention::Pair) = Intervened(x, Intervention(intervention))
intervene(x, interventions::Tuple) =
  Intervened(x, MultiIntervention(map(Intervention, interventions)))

@inline x |ᵈ i = intervene(x, i)