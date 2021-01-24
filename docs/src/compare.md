# Comparison

There are a number of other languages and libraries that have some form of support for causal queries.
Here, we shall look at how these compare to Omega.

## Pyro

Pyro is popular python based probabilistic programming language.


```julia
using OmegaCore, Distributions
p = 0.7
q = 0.3
order = 1 ~ Bernoulli(p)        # court orders execution wiht probability p
Anerves = 2 ~ Bernoulli(q)      # rifleman A has a probability q of pulling the trigger out of nervousness
Ashoots = order |ₚ Anerves
Bshoots = order
dead = Ashoots |ₚ Bshoots
# If the prisoner is dead, then the prisoner would be dead even if rifleman A had not shot

joint = @joint(order, Anerves, Ashoots, Bshoots, dead)
dead_condint = cf(dead, dead, Ashoots => false)
# dead_intcond = (dead |ᵈ (Ashoots => false)) |ᶜ dead 

# Suppose A doesn't shoot and he is dead, would he be dead
# ...Yes because B must have shot in this hypo world to kill 
dead_intcond_a = fc(dead, dead, Ashoots => false)

# Suppose we stopped B's shot but he is still dead, would he be dead had we not
# Yes, because in that world A must have shot, and hence 
dead_intcond_b = fc(dead, dead, Bshoots => false)

## Why are these the same?

joint = @joint(order, Anerves, Ashoots, Bshoots, dead)
mean(randsample(Anerves |ᶜ dead, 10000))
mean(randsample(order |ᶜ dead, 100000))
mean(randsample((Anerves |ᵈ (Anerves => false)) |ᶜ dead, 10000)) 
mean(randsample((joint |ᵈ (Anerves => false)) |ᶜ dead, 10000)) # .886
```

```python
import pyro
import pyro.distributions as dist
from pyro.infer import Importance, EmpiricalMarginal
import torch

p = 0.7
q = 0.3
exogenous_dists = {
    "order": dist.Bernoulli(torch.tensor(p)),
    "Anerves": dist.Bernoulli(torch.tensor(q))
}

def rifleman(exogenous_dists):
    order = pyro.sample("order", exogenous_dists["order"])
    Anerves = pyro.sample("Anerves", exogenous_dists["Anerves"])
    Ashoots = torch.logical_or(order, Anerves)
    Bshoots = order
    dead_ = dead = torch.logical_or(Ashoots, Bshoots)

    # Hack since we can't condition non-derived dists
    dead = pyro.sample("dead", dist.Delta(dead))

    return {"order" : order, "Anerves" : Anerves, "Ashoots" : Ashoots, "Bshoots" : Bshoots, "dead" : dead}

rifleman_cond = pyro.condition(rifleman, data={"dead": torch.tensor(1.0)})
# Sanity check: Exogenous vars become degenerate in posterior
posterior = Importance(
    rifleman_cond,
    num_samples=100).run(exogenous_dists)

# Conditional 
order_marginal = EmpiricalMarginal(posterior, "order")
order_samples = [order_marginal().item() for _ in range(1000)]

Anerves_marginal = EmpiricalMarginal(posterior, "Anerves")
Anerves_samples = [Anerves_marginal().item() for _ in range(1000)]

cf_model = pyro.do(rifleman, {'Ashoots': torch.tensor(0.)})
updated_exogenous_dists = {
    "order": dist.Bernoulli(torch.tensor(mean(order_samples))),
    "Anerves": dist.Bernoulli(torch.tensor(mean(Anerves_samples)))
}
samples = [cf_model(updated_exogenous_dists) for _ in range(100)]
b_samples = [float(b["dead"]) for b in samples]
print("Counterfactual probability of death is", mean(b_samples))
```

In short, this example samples from the posterior of the exogeneous variables, then constructs a new model where (i) these exogenous variables take their posterior values, and (ii) the model structure has been changed through an intervention.

- Although we can compute counterfactual queries, we cannot construct counterfactual models.  
- Interleaves inference computations (e.g., sampling) with construction of counterfactual.  In other words, we cannnot construct a counterfactual that is inference method agnostic
- Can only intervene labelled distributions.  We have had to use the `dist.Delta` trick to be able to condition and intervene transformations of random variables
- Can't take advantage of optimizations

## Notation
A counterfactual in Omega is `(x |ᵈ i) |ᶜ y`.  This may look odd, or even wrong, as it seems to suggest that we are constructing an interventional distribution over `x` and then conditioning that interventional distribution, but that is not the case.
Looking at the expanded form: 

ω -> y(ω) : (x |ᵈ i)(ω) ? ⊥


which in turn is

ω -> (y |ᵈ i)(ω) : x(ω) ? ⊥

## MetaVerse

[Metaverse](https://github.com/babylonhealth/multiverse/blob/master/example_discrete.py) ([Paper](https://arxiv.org/pdf/1910.08091.pdf)) is a python based system for constructing counterfactuals

```julia
using OmegaCore, Distributions

x = 1 ~ Bernoulli(0.0001)
z = 2 ~ Bernoulli(0.001)
noise_flipper = 3 ~ Bernoulli(0.00001)
x_or_z = x.value |ₚ z.value
y = ifelseₚ(noise_flipper, !ₚx_or_z, x_or_z)
x_cf = (x |ᵈ x => 1) |ᶜ y

println("ExpectedValue(Y' | Y = 1, do(X = 1))")
println(mean(randsample(x_cf,  10000)))
```

The corresponding metaverse code is

```python
from multiverse.engine import (
    BernoulliERP,
    DeltaERP,
    ObservableBernoulliERP,
    do,
    observe,
    predict,
    run_inference,
)
from utils import calculate_expectation


def flip_value(val):
    assert val in [0, 1]
    if val == 1:
        return 0
    else:
        return 1



def model_discrete__query_2():
    x = BernoulliERP(prob=0.0001, proposal_prob=0.1)
    z = BernoulliERP(prob=0.001, proposal_prob=0.1)
    y = ObservableBernoulliERP(
        input_val=x.value or z.value,
        noise_flip_prob=0.00001,
        depends_on=[x, z]
    )
    observe(y, 1)
    do(x, 0)
    predict(y.value)


results = run_inference(model_discrete__query_2, 10000)
print("")
print("Counterfactual inference:")
print("ExpectedValue(Y' | Y = 1, do(X = 1))")
print(calculate_expectation(results))
print("***")
```