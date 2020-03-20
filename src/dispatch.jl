using Distributions: Distribution

# # # Dispatch
# # Dispatch intercepts calls to f(\omega)

# function (x::Variable)(ω::T) where {T}
#   if hastag(T, Val{:intervene})
#     handle_intervene(ω.val.tag.intervene, x, ω)
#   end


#   # Scope is relavant to primitives
#   # distributiosn
#   # rand
#   # randm
#   # ...
#   if hastag(T, Val{:scope})
#   end

#   # logpdf is any thing which has logpdf defined
#   # 
#   if hastag(T, Val{:logpdf})
#   end
# end

# function (x::Distribution)(ω)
#   if hastag(T, Val{:scope})
#   end
# end


const Var = Union{Variable, Distribution}

function (f::Var)(ω::AbstractΩ)
  prehook(f, ω)
  ret = recurse(f, ω) # %n
  posthook(ret, f, ω)
end

prehook(f, ω) = nothing
posthook(ret, f, ω) = handle_logpdf(ret, f, ω)

recurse(f::Variable, ω) = f.f(ω)

# How do we go into a function? recurse
# How does excecute work
# When we have a posthook, what if we have more than one?
# How to handle multipe contexts?