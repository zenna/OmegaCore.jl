"A variable is just a function of ω."
struct Variable{F}
  f::F
end
recurse(f::Variable, ω) = f.f(ω)
