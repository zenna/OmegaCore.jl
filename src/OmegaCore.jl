module OmegaCore

using Spec

include("util.jl")              # Utilities
include("namedtuple.jl")        # Named tuple utilities

include("ctx.jl")               # Context

include("tags.jl")              # Tags
include("rng.jl")               # Random number generation

include("id.jl")                # IDs
include("space.jl")             # Sample/Paramter Spaces
include("sample.jl")            # Variables
include("ciid.jl")              # Conditional Independence
include("var.jl")               # Variable

include("primparam.jl")         # Primitive Parameters
include("distributions.jl")     # Primitive Parameters
include("constant.jl")          # Constant distribution 
include("omega.jl")             # Sample Space / Distributions

include("intervene.jl")         # Causal interventions
include("cassette.jl")
include("intervenepass.jl")

include("condition.jl")         # Conditioning variables

include("rejection.jl")         # Rejection sampling Inference
using .OmegaRejectionSample
export RejectionSample

include("logpdf.jl")            # Log density

include("dispatch.jl")          # Dispatch based on tags

# FIXME: Move pointwise to a separate package
include("pointwise.jl")         # Syntactic sugar


# Left to implement:

# - Spec all functions that can be specced
# - Get all specs to run
# - Make tags order invariant
# - 

# automatic id                 
# Static ids                   
# Memoization                  
# argmax                       
# memoization                  
# Get gradients working zygote 
# rand                         
# Replica exchange             
# HMC                          
# Spec automatic testing       
# Metropolis hastings          
# Interact with soft predicates
# Type stability               
# Working intervene            
# Conditioning                 



end