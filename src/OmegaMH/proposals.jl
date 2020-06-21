"Compute a score using the change in prior of the *single* changed site"
function proposalkernel(kernel, x)
  ∇logdensity(x) = x |> transform |> jacobian |> abs |> log
  before = ∇logdensity(x)
  proposed = kernel(x)
  after = ∇logdensity(proposed)
  ratio = after - before
  proposed, ratio 
end

# Do the transform (move unconstrained space)
normalkernel(rng, x, σ = 0.1) = proposalkernel(x) do x
        inv_transform(transform(x) + σ * randn(rng))
      end
# normalkernel(rng, x::Array, σ = 0.1) = normalkernel.(x, σ)

# "Metropolized Independent sample"
# mi(rng, x::T) where T = (rand(rng, T), 0.0)

"Changes a uniformly chosen single site with kernel"
function swapsinglesite(transitionkernel, rng, ω)
  logtranstionp = 0.0
  function updater(x)
    result, logtranstionp = transitionkernel(x)
    result
  end
  update(ω, rand(rng, 1:nelem(ω)), updater), logtranstionp
end

# "Changes a uniformly chosen single site with kernel"
# swapsinglesite(rng, ω) = swapsinglesite(rng, ω) do x 
#   mi(rng, x) 
# end

function moveproposal(rng, ω; σ = 1.0)
  swapsinglesite(rng, ω) do x
    normalkernel(rng, x, σ)
  end
end