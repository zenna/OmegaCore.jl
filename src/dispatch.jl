module Dispatch

using ..Space, ..Var, ..Traits
export ctxapply

# # Dispatch
# In the contextual execution of a variable, every intermediate variable application
# of the form `f(ω)` is __intercepted__.  This allows us to do all kinds of things
# such as do causal interventions, track loglikelihood information, etc
# Our implementation models Cassette.jl

(f::Vari)(ω::Ω) where {Ω <: AbstractΩ} = f(traits(Ω), ω)
(f::Vari)(traits, ω::Ω) where {Ω <: AbstractΩ} = ctxapply(traits, f, ω)

@inline function ctxapply(traits, f, ω::AbstractΩ)
  # FIXME: CAUSATION CAN prehook/recurse change traits?
  prehook(traits, f, ω)
  ret = recurse(f, ω)
  posthook(traits, ret, f, ω)
  ret
end

# by default, pre and posthooks do nothing
@inline prehook(traits, f, ω) = nothing
@inline posthook(traits, ret, f, ω) = nothing

end