export AbstractΩ, defΩ, recurse

# # Sample Space
# A sample space represents a set of possible values.
# Sample spaces are structured in the sense that that are composed of parts.
# Different parts are indicated by an id (see IDS)

"Abstract Sample Space"
abstract type AbstractΩ end

# # Tags
"""
`tag(ω::AbstractΩ, tags)``

tag `ω` with tags.
"""
tag(ω::AbstractΩ, tags) =
  replacetags(ω, mergef(mergetag, ω.tags, tags))

rmtag(ω::AbstractΩ, tag) =
  replacetag(ω, rmkey(ω.tags, tag))

updatetag(ω::AbstractΩ, tag, val) =
  replacetag(ω, update(ω.tags, tag, val))

traithastag(t::AbstractΩ, tag) = traithastag(t.tags, tag)
hastag(ω::AbstractΩ, tag) = hastag(ω.tags, tag)

traits(ω::AbstractΩ) = traits(ω.tags) # FIXME: Do this at the type level

# # Defaults
"Default sample space"
function defΩ end

# FIXME MOve this somewhere (shouldnt really be in AbstractΩ)
"""
`recurse(f, ω)`
Recursively apply contextual execution to internals of `f`"""
function recurse end