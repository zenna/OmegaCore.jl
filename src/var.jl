"""Free Variables
How should variables and random vmariables interact

opt 1:
either I have free variables over parameters or random variables over free parameters
\Omega -> \Phi -> \tau

opt 2.
\Phi -> \Omega -> \tau

opt 3. combine them

Ideally we'd have the flexibility to 
resolve with values for free parametsr and get a random variables
resolve with omega nad get a free parameter
resolve with both


"""
module Var

function f(ϕ)
  a = Real⁺(φ)
  b = Normal(ω, 0, a)
end

μ = var(Real)
b = Normal(μ, 1)
μmax = argmax(μ, entropy(b))

degree = poisson(0.9)
function poly(φ)
  x = 0.0
  function f(x)
    for i = 1:degree(φ)
      x += var(Real)(φ)
    end
    x
  end
end

end