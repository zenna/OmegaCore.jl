# Templates of causal queries
module Queries

using ..Condition: cnd
using ..Interventions: intervene, Intervention, AbstractIntervention

export cf, fc

"""
`cf(x, y, i::Intervention)`

Counterfactual: Given that `y` is true, what would `x` had been `i` been true 

```math
(x \\mid y) \\mid \\text{do}(I)))
```
"""
cf(x, y, i::AbstractIntervention) = intervene(cnd(x, y), i)
cf(x, y, i...) = cf(x, y, Intervention(i...))

"""
`fc(x, y, i::Intervention)`

If in a the hypothetical world `i`, `y` were true, then what is the value of `x`   


```math
x \\mid (y \\mid \\text{do}(I)))
```
# Example
```
using Distributions
order = 1 ~ Bernoulli(0.5)
Anerves = 2 ~ Bernoulli(0.5)
Ashoots = order |ₚ Anerves
Bshoots = order
dead = Ashoots |ₚ Bshoots

# If hypothetically rifleman `C` firing were to kill `B`, then `A` did not fire.
Afc = fc(Bshoots, dead, Ashoots => false)
```

"""
fc(x, y, i::AbstractIntervention) = cnd(x, intervene(y, i))
fc(x, y, i...) = fc(x, y, Intervention(i...))

end