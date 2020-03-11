# # Sample Space
# A sample space represents a set of possible values.
# Sample spaces are structured in the sense that that are composed of parts.
# Different parts are indicated by an id

"Abstract Sample Space"
abstract type AbstractΩ end

# # ID
const ID = NTuple{N, Int} where N


# # Projection 
# A projection of a sample space to some index id is simply.
# Proj is a symbolic representation of this projection

"id'th element of ω, with reference to parent"
struct Proj{OM}
  ω::OM
  id::ID
end

"Project `ω` onto `id`"
@inline proj(ω::AbstractΩ, id) = Proj(ω, id)

"Undo the projection"
@inline unproj(π::Proj) = π.ω

# Projection of a tagged value does the projection and retags
proj(tω::Tagged{<:AbstractΩ}, id) = copytag(tω, proj(tω.val, id))
