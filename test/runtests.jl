using MiniOmega, Statistics

"Bernoulli Distribution"
bernoulli(ω) = ω[1] > 0.5

function f(ω)
  x = bernoulli(ω)
  y = bernoulli(ω)
end

function procedure()
  x = rand()
  y = rand()
  (x, y)
end