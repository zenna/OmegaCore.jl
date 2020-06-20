using OmegaCore
using Test

function testsolution()
  μ = 1 ~ Ordinary(0, 1)
  y = 2 ~ (ω -> Ordinary(μ(ω), 1)(ω))
  μc = μ |ᶜ (y ==ₚ 5.0)
  solution(μc)
end

@testset "Solution" begin
  testsolution()
end