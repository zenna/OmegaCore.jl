module Tagging

export mergetag, hastag, HasTag, NotHasTag, traithastag, Tags

# # Tags
# Many functionalities of Omega are achieved through contextual-execution
# That means we evaluate a function `f(ω)` under some context.
# See Cassette.jl for more information on contextual execution
# Omega uses a poor-mans Cassette, which is more constrained but faster
# Tags are values which are attached to (tagged to) the execution context
# when we evaluate (random) variables.

"Meta data to attach to ω::Ω"
const Tags = NamedTuple

function mergetag end 

# "tag value `val` with tag `tag` and merge tags"
hastag(::Type{Tags{K, V}}, tag::Symbol) where {K, V} = tag in K
hastag(::Type{Tags{K, V}}, tag::Type{Val{S}}) where {K, V, S} = S in K

"Trait type to denote Tagged type with tag"
struct HasTag{T} end

"Trait type to denote Tagged type with absence of tag"
struct NotHasTag{T} end

"`tag(x, tags)` tag value `x` with tags `tags`"
function tag end

"""
Trait function -- `traithastag(t, Val{:sometag})` returns `HasTag{:sometag}`
if `t` has that tag or `NotHasTag{:sometag}` otherwise
"""
traithastag(t::Type{T}, ::Type{Val{S}}) where {T <: Tags, S} = hastag(T, S) ? HasTag{S}() : NotHasTag{S}()
traithastag(t::T, s::Type{Val{S}}) where {T <: Tags, S} = traithastag(T, s)

end