
# A projection of ω to some index id is simply ω[id]
# Proj is a symbolic representation of this projection
# It's useful to maintain a reference to the parent ω

"id'th element of ω, with reference to parent"
struct Proj{OM}
  ω::OM
  id::ID
end

"Project `ω` onto `id`"
proj(ω::Ω, id) = Proj(ω, id)
proj(tω::Tagged{Ω{Z}}, id) where {Z} = copytag(tω, proj(tω.val, id))
@inline unproj(π::Proj) = π.ω

# # Conditional Independence

appendscope(ω, id::ID) = tag(ω, (scope = ID,))
rmscope(ω::Tagged) = rmkeys(ω, :scope)

@inline ciid(f, id) = ω -> f(appendscope(ω, id))
~(id, f) = ciid(f, id)
~(f) = ω -> f(rmscope(ω))
