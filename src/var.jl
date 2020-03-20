abstract type Var end

"A variable is just a function of ω."
struct Variable{F} <: Var
  f::F
end

# The dispatch mechanism works as follows
# Call's to (x::Var)(ω) are intercepted and a pipeline or functions is applied
# The pipeline depends on:
# (1) the type of \omega
# (2) The tags.  Tere is a small, finite number of possible tags: logpdf, memoize, intervene, scope
# (3) type of x

function (x::Var)(ω::T, ::HasIntervene) where {T}
  handle_intervene(ω.val.tag.intervene, x, ω)
end

function (x::Var)(ω::T, ::HasScope)
  # which are the ones with a scope that need to be diminished?

end

(x::Var)(ω::T) where {T} = x(ω, traittags(T))

  # Scope is relavant to primitives
  # distributiosn
  # rand
  # randm
  # ...
  if hastag(T, Val{:scope})
  end

  # logpdf is any thing which has logpdf defined
  # 
  if hastag(T, Val{:logpdf})
  end
end
