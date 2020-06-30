module Var

using Random: AbstractRNG

include("variable.jl")          # Random / Parametric Variables
include("primparam.jl")         # Primitive Parameters
include("distributions.jl")     # Primitive Distributions
include("multivariate.jl")      # Primitive Distributions
include("constant.jl")          # Constant distribution 
include("member.jl")            # Families
include("pointwise.jl")         # Point wise variable application
include("dispatch.jl")          # Contextual application


end
