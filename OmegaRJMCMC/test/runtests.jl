using OmegaCore
using OmegaRJMCMC
using Distributions

"From Green at al"
function poissonmodel()
  # Bayesian model over models
  k = 1 ~ DiscreteUniform(1, 2)
  αλ, βλ = 25, 10
  λ = 2 ~ Gamma(αλ, βλ)
  ακ, βκ = 1, 10
  κ = 3 ~ Gamma(ακ, βκ)

  # Model 1
  Y = ifelse(k ==ₚ 2,
             Poisson(λ),
             NegativeBinomial(λ, κ))

end