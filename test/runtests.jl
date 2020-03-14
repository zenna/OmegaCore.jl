using OmegaCore, Statistics

function f(ω)
  x = normal(ω, 0, 1)
  y = normal(ω, 0, 1)
  x + y
end

sample(f)



# include("rifleman.jl")