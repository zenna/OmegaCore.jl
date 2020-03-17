# # Dispatch
# .. Why do we need a projection when we have a scope?
# .. And the scope is 

abstract type Variable end


# (T::Type{<:Distribution})(ω::MaybeTagged{<:AbstractΩ}, args...) = T(proj(ω, (1,)), args...)


# Variable = Union{}

# function (V::Variable)(tπ::Tagged{<:Proj{OM}}) where OM
#   if hastag(tπ, :intervene)
#     handle_intervene(tπ.val.tag.intervene,)
#   end
# end

# # Handle tags
# function (T::Type{<:Distribution})(tπ::Tagged{<:Proj{OM}}, args...) where {OM}
#   if hastag(tπ, :intervene)
#     handle_intervene(tπ.val.tag.intervene,)
#   end
#   # Project to the scope id (this is what supports conditional independence)
#   ωπ = hastag(tπ, :scope) ? proj(tπ.val.ω, tπ.tag.scope) : tπ.val
#   ret = T(ωπ, args...)
#   if hastag(tπ, :logpdf)
#     handle_logpdf(T, ret, tπ, args...)
#   end
#   ret
# end