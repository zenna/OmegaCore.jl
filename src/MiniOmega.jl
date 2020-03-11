module MiniOmega

const ID = NTuple{N, Int} where N

include("util.jl")              # Utilitiess
include("tags.jl")              # Tags
include("var.jl")               # Variables
include("omega.jl")             # Sample Space / Distributions
                                # Primitive Distributions
include("primparam.jl")         # Primitive Parameters
include("phi.jl")
include("interventions.jl")     # Causal interventions

# include("pointwise.jl")       # Syntactic sugar


end