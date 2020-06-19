module OmegaGrad

using Reexport

export lineargradient, back!, GradAlg, value, grad

"Gradient Algorithm"
abstract type GradAlg end

"`lineargradient(::RandVar, ω::Ω, ::Alg)` Returns as vector gradient of ω components"
function lineargradient end

"`back!(::RandVar, ω::Ω, ::TrackerGradAlg)` update ω s.t ω[id].grad is gradient"
function back! end

"`grad(rv, ω)` returns ω where gradients in components"
function grad end

"Value associated with dual/tracked/etc number/array"
function value end

include("zygote.jl")
@reexport using OmegaZygote

end # module
