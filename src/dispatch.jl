using Distributions: Distribution

# # Dispatch
# Dispatch intercepts calls to f(\omega)

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

function (x::Distribution)(ω)
  if hastag(T, Val{:scope})
  end
end