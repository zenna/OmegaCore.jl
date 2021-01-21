module Syntax

using ..OmegaCore.Util: mapf
export @joint

"""
Random variable over named tuple using varnames as keys

`@joint randvar1 randvar2 ...`

```julia
using Distributions
a = 1 ~ Normal(0, 1)
b = 2 ~ Normal(0, 1)
c = a >=ₚ b
randsample(@joint a b c)
=> (Ashoots = false, Bshoots = false)
```
"""
macro joint(args::Symbol...)
  esc(:(ω -> NamedTuple{$args}(OmegaCore.Util.mapf(ω, tuple($(args...))))))
end

end