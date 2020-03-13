module MiniOmega


export sample, ID

include("util.jl")              # Utilities
include("namedtuple.jl")        # Named tuple utilities

include("tags.jl")              # Tags
include("rng.jl")               # Random number generation

include("id.jl")                # IDs
include("space.jl")             # Sample/Paramter Spaces
include("var.jl")               # Variables
include("ciid.jl")              # Conditional Independence

include("primparam.jl")         # Primitive Parameters
include("omega.jl")             # Sample Space / Distributions
include("dist.jl")              # Primitive Distributions
# include("phi.jl")
include("interventions.jl")     # Causal interventions

# include("pointwise.jl")       # Syntactic sugar


end