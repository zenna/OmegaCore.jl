@inline function handle_intervene(i::Intervention{X, V}, x::X, ω) where {X, V}
  if i.x == x
    i.v(ω)
  else
    x.f(ω)
  end
end

@inline handle_intervene(ctx, ::Intervention, x, ω) = Cassette.recurse(ctx, x, ω)


# Option 1.
# mak rules for scoped and for variable

# Opt 2.
# Make scoped a subtype of variable

# Opt 3
# Ensure F is a variable in scoped,


