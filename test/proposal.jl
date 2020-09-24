using OmegaCore
using Test

function propose(::typeof(x), x_, ω)
  if μ in keys(ω.data) && StdUnif(2) in keys(ω.data)
    return nothing
    # @assert false
  
  ## FIXME< seem to be some numerical issues
  elseif μ in keys(ω.data)
    c(x) = cdf(Normal(0, 1), x)
    Dict{Any, Any}(StdUnif(2) => c(x_ - ω.data[μ]))
  elseif StdUnif(2) in keys(ω.data)
    nothing
  end
    ## Provide a value for μ
    # @assert false
end

function test()
  x_ = 3.5
  ω = Ω(Dict{Any, Any}(x => x_))
  propose(μ, ω)
end

