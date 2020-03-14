"Rejection Sampling"
struct RejectionSample end

function sample(rng, ΩT::Type{OT}, f, n, alg::Type{RejectionSample}) where OT
  ωsamples = ΩT[]
  accepted = 0
  i = 1
  while accepted < n
    ω = sample(rng, ΩT)
    issat = pred(Omega.Space.tagrng(ω, rng))
    if issat
      push!(ωsamples, ω)
      accepted += 1
    end
    i += 1
  end
  ωsamples
end


# Make version for x(\omega)
# Decide about rng
# Make parallel
# Avoid doing everything twice