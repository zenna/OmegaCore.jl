@inline function handle_intervene(i::Intervention{X, V}, x::X, ω) where {X, V}
  if i.x == x
    i.v
  else
    x(ω)
  end
end

@inline handle_intervene(ctx, ::Intervention, x, ω) = Cassette.recurse(ctx, x, ω)
