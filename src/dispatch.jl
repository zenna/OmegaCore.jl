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
  # FIXME: CAUSATION CAN prehook/recurse change TRAITS?
  prehook(traits, f, ω)
  ret = recurse(f, ω)
  posthook(traits, ret, f, ω)
  ret
end

# prehook(f, ω::Ω) where Ω = prehook(traits(Ω), f, ω)
prehook(traits, f, ω) = nothing

# posthook(ret, f, ω::Ω) where Ω = posthook(traits(Ω), ret, f, ω)
posthook(traits, ret, f, ω) = nothing


# posthook(ret, f, ω) = handle_logpdf(ret, f, ω)

# pass(f, ω) = passintervene(f, ω)

# overdub(f, ω) = handle_memoizehandle_intervene(f, ω)

# How do we go into a function? recurse
# How does excecute work
# When we have a posthook, what if we have more than one?
# How to handle multipe contexts?

# this is a bit confusing.
# I am not sure all the behaviours specific to different tags are of the same type.
# logpdf - just updates the context
# memoize - replaces f(x) with some value
# intervene - replaces f with some f'

end