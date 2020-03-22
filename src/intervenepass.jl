# @inline hasintervene(ω) = hastag(ω, Val{:intervene})
@inline tagintervene(ω, intervention) = tag(ω, (intervene = intervention,))

@inline (x::Intervened)(ω) = x.x(tagintervene(ω, x.i))

@inline function passintervene(i::Intervention{X, V}, x::X, ω) where {X, V}
  if i.x == x
    (i.v, ω)
  else
    (x, ω)
  end
end

@inline passintervene(i::Intervention, x, ω) = (x, ω)

passintervene(f, ω) = passintervene(traithastag(ω.tags, Val{:intervene}), f, ω)
passintervene(::HasTag{:intervene}, f, ω) = passintervene(ω.tags.intervene, f, ω)
passintervene(::NotHasTag{:intervene}, f, ω) = (f, ω)
