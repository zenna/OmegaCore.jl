# # Causal interventions
using Cassette
export |ᵈ
Cassette.@context OmegaCtx

# What's the logic of interventions 
# How to avoid nested contexts

"The assertion that `x` should be replaced to value `v`"
struct Intervention{X, V}
  x::X
  v::V
end

Intervention(x::Pair) = Intervention(x.first, x.second)

"Intervened Variable: `x` had intervention `i` been the case"
struct Intervened{X, I}
  x::X
  i::I
end

# if there's already a context append to it
@inline (x::Intervened)(ω) = Cassette.overdub(OmegaCtx(metadata = (intervention = x.i,)), x.x, ω)

test(ctx::OmegaCtx{NamedTuple{K, V}}) where {K, V} = K

function Cassette.overdub(ctx::OmegaCtx{NamedTuple{K, V}}, x, ω::MaybeTagged{<:AbstractΩ}) where {K, V}
  # @show K
  # if :intervention in K
  #   :(
      handleintervention(ctx, ctx.metadata.intervention, x, ω)
      # )
  # else
  #   :(Cassette.recurse(ctx, x, ω))
  # end
end

@inline function handleintervention(ctx, i::Intervention{X, V}, x::X, ω) where {X, V}
  if i.x == x
    i.v
  else
    Casstte.recurse(ctx, x, ω)
  end
end

@inline handleintervention(ctx, ::Intervention, x, ω) = Cassette.recurse(ctx, x, ω)

# # Syntactic Sugar

|ᵈ(x, intervention::Intervention) = Intervened(x, Intervention)
|ᵈ(x, intervention) = Intervened(x, Intervention(intervention))
