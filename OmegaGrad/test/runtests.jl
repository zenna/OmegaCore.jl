using OmegaCore, OmegaGrad, Distributions
# using OmegaTestModels


# import ForwardDiff
# using Flux

# const ΩTs = [LinearΩ{Vector{Int}, UnitRange{Int64}, Vector{Float64}},
#              Omega.SimpleΩ{Vector{Int}, Float64},
#              LinearΩ{Vector{Int}, UnitRange{Int64}, TrackedArray{Float64, 1, Array{Float64,1}}}]

# const gradalgs = [Omega.TrackerGrad,
#                   Omega.ForwardDiffGrad,
#                   # Omega.ZygoteGrad
#                   ]

# function testgrad(OT = Omega.SimpleΩ{Vector{Int}, Float64})
#   μ = uniform(0.0, 1.0)
#   x = normal(μ, 1.0) + normal(μ, 1.0)
#   y = logerr(x ==ₛ 1.0)
#   ω = OT()
#   y(ω)
#   Omega.lineargradient(y, ω, Omega.ForwardDiffGrad)
# end

# testgrad(LinearΩ{Vector{Int}, UnitRange{Int64}, Vector{Float64}})

# # Test them all
# istracked(::Type{LinearΩ{I, SEG, T}}) where {I, SEG, T <: TrackedArray} = true
# istracked(ΩT) = false

# function testgrad2(; modelcond, ΩT, gradalg)
#   @show ΩT  
#   println()
#   Omega.lineargradient(logerr(modelcond), ΩT(), gradalg)
# end

# # Filter to differentiable models
# models = filter(hascond ∧ isdiff, allmodels)

# # Dont use TrackerGrad on wrong Omegas, etc
# f1(m, ΩT, gradalg) = gradalg == Omega.TrackerGrad ?  istracked(ΩT) : true
# f2(m, ΩT, gradalg) = gradalg == Omega.ForwardDiffGrad ? !istracked(ΩT) : true

# function runtests()
#   for model in models, gradalg in gradalgs, ΩT in ΩTs
#     if f1(model, ΩT, gradalg) && f2(model, ΩT, gradalg)
#       @show model.name
#       @show ΩT
#       @show gradalg  
#       testgrad2(; modelcond = model.cond, ΩT = ΩT, gradalg = gradalg)
#     end
#   end
# end

# runtests()

function zygotetest_1()
  x = 1 ~ Normal(0, 1)
  y = 2 ~ Normal(0, 1)
  z(ω) = x(ω) + y(ω)
  ω = defω()
  x_ = x(ω)
  y_ = y(ω)
  @test grad(z, ω, ZygoteGrad) = (1.0, 1.0)
end

function zygotetest_2()
  x = [i ~ Normal(0, 1) for i = 1:5]
  y(ω) = sum(x(ω))
  ω = defω()
  y_ = y(ω)
  @test grad(y, ω, ZygoteGrad) = (1.0,1.0,1.0,1.0,1.0)
end

function zygotetest_3()
  x = 1 ~ Normal(0, 1)
  y = 2 ~ Normal(0, 1)
  z(ω) = x(ω) * y(ω)
  ω = defω()
  x_ = x(ω)
  y_ = y(ω)
  @test grad(z, ω, ZygoteGrad) = (ω.data[[2]][2], ω.data[[1]][2])
end

function zygotetest_4()
  x = 1 ~ Normal(0, 1)
  z(ω) = x(ω) * x(ω) * x(ω)
  ω = defω()
  x_ = x(ω)
  @test grad(z, ω, ZygoteGrad) = (3.0 * (ω.data[[1]][2] ^ 2),)
end

function zygotetest_5()
  x = 1 ~ Normal(0, 1)
  z(ω) = sin(x(ω))
  ω = defω()
  x_ = x(ω)
  @test grad(z, ω, ZygoteGrad) = (cos(ω.data[[1]][2]),)
end

@testset "Gradients" begin
  zygotetest_1()
  zygotetest_2()
  zygotetest_3()
  zygotetest_4()
  zygotetest_5()
end