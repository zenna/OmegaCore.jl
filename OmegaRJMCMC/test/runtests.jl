using OmegaCore
# using OmegaRJMCMC
using Distributions

"From Green at al"
function poissonmodel()
  # Bayesian model over models
  k = 1 ~ DiscreteUniform(1, 2)
  αλ, βλ = 25, 10
  λ = 2 ~ Gamma(αλ, βλ)
  ακ, βκ = 1, 10
  κ = 3 ~ Gamma(ακ, βκ)

  q = Poissonₚ(λ)

  # This is literal pointwise semanics
  q(ω) -> Poisson(λ(ω))

  So that makes sense, but
  we want kind of parity with parameters
  Poission(0.4) produces a ciid class
  lift(Poisson)(λ) produces a distribution over ciid classes
  

  q(id, ω) = Poisson(λ(ω))(id, ω)

  into 

  (id, ω) -> Poisson(_)(id, ω)

  The problem with this reduction is that we would need to ensure hte \oemgas are consistent

  What's to stop me form violating that.
  In this snse i cant see it as a valid independent procedure.

  u might say the general mechanism is just partial application.


  I'm not sure what it should produce.
  On the one hand the lifted notation makes sense because its the literal
  extention of lifting.

  On the other hand, the version that produces a `ciid` makes sense too.
  Practically, if we have Mv(i)

  Option 1: Partial application-
  Option 2: specialise to this classes
  Option 3: just use special types

  @inline Space.recurse(mv::Mv{<:Distribution}, id, ω) =
    recurse(Mv(mv.dist(ω)), id, ω)



  # Model 1
  N = 10
  Y = pw(ifelse)(l(k ==ₚ 2),
             4 ~ Mv(Poissonₚ(λ), N),
             5 ~ Mv(NegativeBinomialₚ(λ, κ), N))

end

# function test()
#   function f(id, ω)
#     x = (id, 1) ~ Normal(0, 1)
#     y = (id, 1) ~ Normal(0, 1)
#     x(ω) + y(ω)
#   end
#   z = Normal(f, 1)

randsample(poissonmodel())