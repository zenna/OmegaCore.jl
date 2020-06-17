
import ..Traits
using ..Traits: Trait
export Err, LogPdf, Mem, Intervene, Rng, Scope

# # Primitive Traits
struct Err <: Trait end
struct LogPdf <: Trait end
struct Mem <: Trait end
struct Intervene <: Trait end
struct Rng <: Trait end
struct Scope <: Trait end

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
Traits.traits(::Tags{K, V}) where {K, V} = Union{map(symtotrait, K)...}
Traits.traits(::Type{Tags{K, V}}) where {K, V} = Union{map(symtotrait, K)...}

