using Distributions
using OmegaCore
using Test

const μ = 1 ~ Normal(0, 1)
const y = 2 ~ ((id, ω) -> Normal(μ(ω), 1)(id, ω)) 


function testsolution()
  μ = 1 ~ Normal(0, 1)
  y = 2 ~ ((id, ω) -> Normal(μ(ω), 1)(id, ω)) 
  μc = μ |ᶜ (y ==ₚ 5.0)
  @test_throws OmegaCore.ConditionException solution(μc)  
  solution(μc)
end

function test_solution_intervene()
  μ = 1 ~ Normal(0, 1)
  y = 2 ~ ((id, ω) -> Normal(μ(ω), 1)(id, ω)) 
  μc = μ |ᶜ (y ==ₚ 5.0)
  yi = y |ᵈ (μ => (ω -> 100.0))
  yi2 = y |ᵈ (μ => (ω -> 100))
  ω = solution(μc)
  (yi(ω), y(ω))
  # ω2 = solution((μc, yi))
end

@testset "Solution" begin
  testsolution()
end