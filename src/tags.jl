# # Tags
# Tags attach meta-data which modulates function application.

"Meta data to attach to ω::Ω"
const Tags{K, V} = NamedTuple{K, V}

function mergetag end 

# "tag value `val` with tag `tag` and merge tags"
hastag(::Type{Tags{K, V}}, tag::Symbol) where {K, V} = tag in K
hastag(::Type{Tags{K, V}}, tag::Type{Val{S}}) where {K, V, S} = S in K

"Trait type to denote Tagged type with tag"
struct HasTag{T} end

"Trait type to denote Tagged type with absence of tag"
struct NotHasTag{T} end

"""
Trait function -- `traithastag(t, Val{:sometag})` returns `HasTag{:sometag}`
if `t` has that tag or `NotHasTag{:sometag}` otherwise
"""
traithastag(t::Tags, ::Type{Val{S}}) where S = hastag(t, S) ? HasTag{S}() : NotHasTag{S}()
traithastag(t::Type{T}, ::Type{Val{S}}) where {T <: Tags, S} = hastag(T, S) ? HasTag{S}() : NotHasTag{S}()


