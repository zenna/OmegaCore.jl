# # Tags
# Tags attach meta-data which modulates function application.

"A value `val` tagged with data `tag`"
struct Tagged{T, NT}
  val::T
  tag::NT
end

const MaybeTagged{T, NT} = Union{T, Tagged{T, NT}}

function mergetag end 

"tag value `val` with tag `tag` and merge tags"
@inline tag(val, tag) = Tagged(val, tag)
@inline tag(val::Tagged, tag) = Tagged(val.val, mergef(mergetag, val.tag, tag))

@inline rmtag(t, tag) = Tagged(t.val, rmkey(t.tag, tag))
@inline updatetag(t, tag, val) = Tagged(t.val, update(t.tag, tag, val))

hastag(::Type{Tagged{T, NamedTuple{K, V}}}, tag::Symbol) where {T, K, V} = tag in K
hastag(::T, tag::Symbol) where {T <: Tagged } = hastag(T, tag)
@generated function hastag(t::T, tag::Type{Val{TAG}}) where {T <: Tagged, TAG}
  hastag(T, TAG)
end

# Tag Traits
"Trait type to denote Tagged type with tag"
struct HasTag{T} end

"Trait type to denote Tagged type with absence of tag"
struct NotHasTag{T} end

"""
Trait function -- `traithastag(t, Val{:sometag})` returns `HasTag{:sometag}`
if `t` has that tag or `NotHasTag{:sometag}` otherwise
"""
traithastag(t, ::Type{Val{T}}) where T = hastag(t, T) ? HasTag{T}() : NotHasTag{T}()
