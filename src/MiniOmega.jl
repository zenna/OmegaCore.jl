module MiniOmega

using Distributions: Distribution
import Distributions: logpdf

const ID = NTuple{N, Int} where N

include("tags.jl")
include("omega.jl")
include("interventions.jl")


end