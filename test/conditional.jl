using OmegaCore

function test_pos_measure()
  x(ω) = Normal(ω, 0, 1)
  y(ω) = x(ω) > 0
  x_cond = x |ᶜ y
  sample(x_cond)
end

x = 1 ~ Poisson(1.3)
function f(ω)
  n = x(ω)
  x = 0.0
  for i = 1:n
    x += (i + 1) ~ Normal(0, 1)(ω)
  end
  x
end

f_ = f | (x ==ₛ 3.0)
g_ = ω -> (x(ω), f_(ω))


θ = ~ Normal(0, 1)
x = [Normal(0, 1) for i = 1:5]
θ |