# # Dispatch
# Dispatch intercepts calls to f(\omega)

function (x::Variable)(ω::T) where {T}
  if hastag(T, Val{:intervene})
    handle_intervene(ω.val.tag.intervene, x, ω)
  end

  if hastag(T, Val{:scope})
  end

  if hastag(T, Val{:logpdf})
  end
end
