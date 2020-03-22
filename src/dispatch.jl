using Distributions: Distribution

"Variable"
const Var = Union{Variable, Distribution}

function (f::Var)(ω::AbstractΩ)
  f_, ω_ = pass(f, ω)
  # @show f_
  # @show ω_
  prehook(f_, ω_)
  @show ret = recurse(f_, ω_)
  posthook(ret, f_, ω_)
end

prehook(f, ω) = nothing
posthook(ret, f, ω) = handle_logpdf(ret, f, ω)

pass(f, ω) = passintervene(f, ω)

overdub(f, ω) = handle_memoizehandle_intervene(f, ω)

# How do we go into a function? recurse
# How does excecute work
# When we have a posthook, what if we have more than one?
# How to handle multipe contexts?


# this is a bitt confusing.
# I am not sure all the behaviours specific to different tags are of the same type.
# logpdf - just updates the context
# memoize - replaces f(x) with some value
# intervene - replaces f with some f'
