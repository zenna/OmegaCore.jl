module Space

import ..Tagging: hastag, traithastag, tag
import ..Traits: traits

# # Concrete
# These are concrete data structures that implement the AbstractΩ structure,
# associating ids with values. 

# Sample / Parameter Space
include("abstractomega.jl")     # Abstract sample/Paramter Spaces
include("scope.jl")
include("simpleomega.jl")       # Sample Space / Distributions
include("lazyomega.jl")         # Sample Space / Distributions

end