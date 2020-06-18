
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
# Traits.traits(::Tags{K, V}) where {K, V} = Union{map(symtotrait, K)...}
# Traits.traits(::Type{Tags{K, V}}) where {K, V} = Union{map(symtotrait, K)...}


@generated function Traits.traits(k::Tags{K, V}) where {K, V}
  traits_ = map(symtotrait, K)
  Expr(:curly, :Union, traits_...)
end

@generated function Traits.traits(k::Type{Tags{K, V}}) where {K, V}
  # Core.println(K)
  traits_ = map(symtotrait, K)
  # Core.println(traits_)
  Expr(:curly, :Union, traits_...)
end