
import ..Traits
using ..Traits: Trait
export Err, LogPdf, Mem, Intervene, Rng, Scope

# # Primitive Traits
struct Err end
struct LogPdf end
struct Mem end
struct Intervene end
struct Rng end
struct Scope end

function symtotrait(x::Symbol)
  if x == :err
    Err
  elseif x == :logpdf
    LogPdf
  elseif x == :mem
    Mem
  elseif x == :intervene
    Intervene
  elseif x == :rng
    Rng
  elseif x == :scope
    Scope
  else
    error("Unknown trait: $x")
  end
end

@generated function Traits.traits(k::Tags{K, V}) where {K, V}
  traits_ = map(symtotrait, K)
  Core.println(traits_)
  Trait{Union{traits_...}}()
end

@generated function Traits.traits(k::Type{Tags{K, V}}) where {K, V}
  traits_ = map(symtotrait, K)
  Trait{Union{traits_...}}()
end