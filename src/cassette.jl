
# function Cassette.overdub(ctx::OmegaCtx{NamedTuple{K, V}}, x, ω::MaybeTagged{<:AbstractΩ}) where {K, V}
#   # @show K
#   # if :intervention in K
#   #   :(
#       handleintervention(ctx, ctx.metadata.intervention, x, ω)
#       # )
#   # else
#   #   :(Cassette.recurse(ctx, x, ω))
#   # end
# end

# @inline function handleintervention(ctx, i::Intervention{X, V}, x::X, ω) where {X, V}
#   if i.x == x
#     i.v
#   else
#     Casstte.recurse(ctx, x, ω)
#   end
# end

# @inline handleintervention(ctx, ::Intervention, x, ω) = Cassette.recurse(ctx, x, ω)

# # # Syntactic Sugar