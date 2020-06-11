module Var

using Random: AbstractRNG

# Random / Parametric Variables
include("variable.jl")               # Variable
include("primparam.jl")         # Primitive Parameters
include("distributions.jl")     # Primitive Distributions
include("constant.jl")          # Constant distribution 

end
