using OmegaCore

function f(ω)
  x = rand(ω)
  y = randn(ω)
end

a = 1 ~ Normal(0, 1)
