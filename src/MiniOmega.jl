module MiniOmega


export sample, ID

include("util.jl")              # Utilitiess
include("tags.jl")              # Tags

include("space.jl")             # Sample/Paramter Spaces
include("var.jl")               # Variables

include("primparam.jl")         # Primitive Parameters
include("omega.jl")             # Sample Space / Distributions
include("dist.jl")              # Primitive Distributions
# include("phi.jl")
include("interventions.jl")     # Causal interventions

# include("pointwise.jl")       # Syntactic sugar


end