module OmegaRejectionSample
import Base.Threads

import ..OmegaCore
const OC = OmegaCore
import ..OmegaCore: randsample

export RejectionSample, randsample

"Rejection Sampling  Algorithm"
struct RejectionSampleAlg end
const RejectionSample = RejectionSampleAlg()

function condomegasample1(rng,
                     ΩT::Type{OT},
                     y,
                     n,
                     alg::RejectionSampleAlg) where OT
  @label restart
  ω = OC.initΩ(rng, ΩT)
  !y(ω) && @goto restart
  ω
end

"`n` samples from ω::ΩT such that `y(ω)` is true"
function OC.condomegasample(rng,
                       ΩT::Type{OT},
                       y,
                       n,
                       alg::RejectionSampleAlg) where OT
  ωsamples = Vector{Any}(undef, n)  # Fixme
  accepted = 0
  i = 1
  rngs = OC.duplicaterng(rng, Threads.nthreads())
  Threads.@threads for i = 1:n
    rng = rngs[Threads.threadid()]
    @inbounds ωsamples[i] = condomegasample1(rng, ΩT, y, n, alg)
  end
  ωsamples
end

function OC.randsample(rng,
                       ΩT::Type{OT},
                       x,
                       n,
                       alg::RejectionSampleAlg) where {OT}
  # introduce conditions
  # y = OC.mem(OC.indomain(x))
  y = OC.conditions(x)
  ωsamples = OC.condomegasample(rng, ΩT, y, n, alg)
  # map(OC.mem(x), ωsamples)
  map(x, ωsamples)
end

end