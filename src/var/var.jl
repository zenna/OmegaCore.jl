module Var

export Vari
using Random: AbstractRNG

include("variable.jl")          # Random / Parametric Variables
include("primparam.jl")         # Primitive Parameters
include("distributions.jl")     # Primitive Distributions
include("constant.jl")          # Constant distribution 
include("member.jl")            # Families
include("pointwise.jl")         # Point wise variable application

"Interceptable Variable"
const Vari = Union{Variable}

end
