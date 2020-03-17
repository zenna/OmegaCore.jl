module OmegaCore

include("util.jl")              # Utilities
include("namedtuple.jl")        # Named tuple utilities

include("ctx.jl")               # Context

include("tags.jl")              # Tags
include("rng.jl")               # Random number generation

include("id.jl")                # IDs
include("space.jl")             # Sample/Paramter Spaces
include("sample.jl")            # Variables
include("ciid.jl")              # Conditional Independence

include("primparam.jl")         # Primitive Parameters
include("omega.jl")             # Sample Space / Distributions

include("dispatch.jl")          # Primitive Distributions
# include("phi.jl")


include("intervene.jl")     # Causal interventions
include("cassette.jl")
include("causal.jl")


include("pointwise.jl")       # Syntactic sugar

include("condition.jl")         # Condition these variables


include("rejection.jl")         # Inference

# Left to implement:
# conditioning 
# argmax
# Get gradients working zygote
# rand
# automatic id
# workint intervene
# memoization
# Type stability
# Replica exchange
# Metropolis hastings
# HMC
# interact with soft predicates

end