using Test
#FIXME, put this into a testing module
function isinferred(f, args...; allow = Union{})
  ret = f(args...)
  inftypes = Base.return_types(f, Base.typesof(args...))
  rettype = ret isa Type ? Type{ret} : typeof(ret)
  rettype <: allow || rettype == Test.typesubtract(inftypes[1], allow)
end

@testset "alltests" begin
  include("ciid.jl")
  include("logpdf.jl")
  include("condition.jl")
  include("intervene.jl")
  include("tagging.jl")
end