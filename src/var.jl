"A variable is just a function of ω."
struct Variable{F}
  f::F
end

function (x::Variable)(ω::T) where {T}
  if hastag(T, Val{:intervene})
    handle_intervene(ω.val.tag.intervene, x, ω)
  end


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
