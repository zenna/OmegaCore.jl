# # Causal interventions
export |ᵈ, intervene

"The assertion that `x` should be replaced to value `v`"
struct Intervention{X, V}
  x::X
  v::V
end

Intervention(x::Pair) = Intervention(x.first, x.second)

"Intervened Variable: `x` had intervention `i` been the case"
struct Intervened{X, I}
  x::X
  i::I
end

"intervened"
intervene(x, intervention::Intervention) = Intervened(x, Intervention)
intervene(x, intervention) = Intervened(x, Intervention(intervention))

@inline x |ᵈ i = intervene(x, i)