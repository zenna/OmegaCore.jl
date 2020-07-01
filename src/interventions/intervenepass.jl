using ..Tagging, ..Traits, ..Var, ..Space
# @inline hasintervene(ω) = hastag(ω, Val{:intervene})
@inline tagintervene(ω, intervention) = tag(ω, (intervene = intervention,))
@inline (x::Intervened)(ω) = x.x(tagintervene(ω, x.i))

@inline function passintervene(traits, i::Intervention{X, V}, x::X, ω) where {X, V}
  # If the variable ` x` to be applied to ω is the variable to be replaced
  # then replace it, and apply its replacement to ω instead.
  # Othewise proceed as normally
  if i.x == x
    i.v(ω)
  else
    ctxapply(traits, x, ω)
  end
end

function passintervene(traits,
                       i::MultiIntervention{NTuple{N, Intervention{X, V}}},
                       x::X,
                       ω) where {X, V, N <: Int}
  # @show typeof(i.is[1].x)
  is = filter(i -> x == i.x, i.is)
  if !isempty(is)
    is[1].v(ω)
  else
    ctxapply(traits, x, ω)
  end
end

# We only consider intervention if the intervention types match
@inline passintervene(traits, i::AbstractIntervention, x, ω) =
  ctxapply(traits, x, ω)

(f::Vari)(traits::trait(Intervene), ω::AbstractΩ) = 
  passintervene(traits, ω.tags.intervene, f, ω)