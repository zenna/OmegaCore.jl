module OmegaCore

using Reexport
using Spec

include("util/util.jl")         # General utilities
using .Util

include("traits.jl")
@reexport using .Traits

include("tagging/tagging.jl")      # Tags
using .Tagging

include("rng.jl")               # Random number generation
using ..RNG

include("ids/ids.jl")                # IDs
@reexport using .IDS

include("space/space.jl")       # Probability / Paramter Spaces
@reexport using .Space

include("var/var.jl")           # Random / Parameteric Variables
@reexport using .Var

# include("ciid.jl")              # Conditional Independence
# @reexport using .CIID

# include("dispatch.jl")          # Dispatch based on tags
# using .Dispatch

include("interventions/interventions.jl")         # Causal interventions
@reexport using .Interventions

include("cassette.jl")

include("condition.jl")         # Conditioning variables
@reexport using .Condition

include("sample.jl")            # Sample
@reexport using .Sample

include("trackerror.jl")
using .TrackError

# include("logpdf.jl")            # Log density
# @reexport using LogPdf

include("solution.jl")               # Satisfy
@reexport using .Solution

# Basic Inference methods
# include("fail.jl")              # Fails when conditions are not satisfied
# @reexport using .Fail

include("rejection.jl")         # Rejection sampling Inference
@reexport using .OmegaRejectionSample

include("pointwise.jl")
@reexport using .Pointwise

end