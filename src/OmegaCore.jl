module OmegaCore

using Reexport
using Spec

include("util/util.jl")         # General utilities
using .Util

include("tagging/tagging.jl")      # Tags
using .Tagging

include("rng.jl")               # Random number generation
using ..RNG

include("id.jl")                # IDs
@reexport using .IDS

include("space/space.jl")       # Probability / Paramter Spaces
@reexport using .Space

include("var/var.jl")           # Random / Parameteric Variables
@reexport using .Var

include("ciid.jl")              # Conditional Independence
@reexport using .CIID

include("interventions/interventions.jl")         # Causal interventions
@reexport using .Interventions

include("cassette.jl")

include("condition.jl")         # Conditioning variables
@reexport using .Condition

include("sample.jl")            # Sample
@reexport using .Sample

# Basic Inference methods
# include("fail.jl")              # Fails when conditions are not satisfied
# @reexport using .Fail

include("rejection.jl")         # Rejection sampling Inference
@reexport using .OmegaRejectionSample

include("logpdf.jl")            # Log density
# include("sat.jl")               # Satisfy

include("dispatch.jl")          # Dispatch based on tags

include("trackerror.jl")

# # FIXME: Move to a separate package
# include("syntax/syntax.jl")         # Syntactic sugar
# @reexport using .OmegaSyntax

# Left to implement:

# - Spec all functions that can be specced
# - Get all specs to run
# - Make tags order invariant
# - 

# automatic id                 
# Static ids                   
# argmax                       
# memoization                  
# rand
# Add parallel Replica exchange             
# HMC                          
# Get gradients working zygote
# Spec automatic testing       
# Metropolis hastings          
# Interact with soft predicates
# Type stability               
# Working intervene            
# Conditioning                 



end