module Space

import ..Tagging: hastag, traithastag, tag
import ..Traits: traits

# Sample / Parameter Space
include("abstractomega.jl")     # Abstract sample/Paramter Spaces
# include("scope.jl")
include("simpleomega.jl")       # Sample Space / Distributions
include("lazyomega.jl")         # Sample Space / Distributions

# Defaults
defΩ(args...) = LazyΩ{EmptyTags, Dict{defID(), Tuple{Any, Any}}}
defω(args...) = tagrng(defΩ()(), Random.GLOBAL_RNG)

end