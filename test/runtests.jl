using Test
#FIXME, put this into a testing module
function isinferred(f, args...; allow = Union{})
  ret = f(args...)
  inftypes = Base.return_types(f, Base.typesof(args...))
  rettype = ret isa Type ? Type{ret} : typeof(ret)
  rettype <: allow || rettype == Test.typesubtract(inftypes[1], allow)
end

@testset "alltests" begin
  include("typeinfer.jl")
  include("ciid.jl")
  include("condition.jl")
  include("distributions.jl")
  include("core.jl")
  include("intervene.jl")
  include("logpdf.jl")
  include("multivariate.jl")
  include("namedtuple.jl")
  include("solution.jl")
  include("tagging.jl")
  include("typeinfer.jl")
  include("var.jl")
end