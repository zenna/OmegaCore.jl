# # Causal interventions
using Cassette
export had

# Intervention Context
Cassette.@context HadCtx
"The assertion that `x` should be replaced to value `v`"
struct Intervention{X, V}
  x::X
  v::V
end

"`x` had `i` been the case"
function had(x, i::Intervention)
  let ctx = HadCtx(metadata = i)
    ω -> Cassette.overdub(ctx, x, ω)
  end
end

function Cassette.overdub(ctx::HadCtx{Intervention{X, V}}, x::X, ω::AbstractΩ) where {X, V}
  if x == ctx.metadata.x
    @show :true
    ctx.metadata.v
  else
    @show :false
    Cassette.recurse(ctx, x, ω)
  end
end

# Sugar

"Examples Syntax for `x | had(3 => x)`"
had(xtov::Pair) = Intervention(xtov.first, xtov.second)
Base.:|(x, i::Intervention) = had(x, i)
