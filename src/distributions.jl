using Distributions: Distribution

struct Model{D, PARAMS}
  x::D
  params::PARAMS
end

# Todo, specialise this to 1,2,3,4,5 arguments
(m::Model)(ω) = m.x((liftapply(p, ω) for p in m.params)...)(ω)  
(x::Type{<:Distribution})(params...) = Model(x, params)