using MiniOmega

@omega begin
  n = ~ finite(1:10)
  μ = ~ [normal(0, 1) for i = 1:n]
  s = sum(μ)
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