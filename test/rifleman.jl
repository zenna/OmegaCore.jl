# From Example From Causality, Page 212
using MiniOmega
using Test
# The court orders an executiion with probability 0.5
court_order = rv(bernoulli(0.5, 1))

# With probability 0.5 the rifleman is nervous and fires
A_nervous = rv(bernoulli(0.5, 2))

# Rifleman A and B both fire if the court orders the exectuion
# Hint: Functions (such as | 'or' ) of random variables are defined pointwise
riflemanA = court_order | A_nervous
riflemanB = court_order

# Prisoner dies if either shoots
dead = riflemanA | riflemanB

# Let's compute the probability that prisoner is still alive if A had not shot,
# given that he is actually dead?

# Is the prisoner dead, supposing that riflemanA did not actually shoot?
alt_dead = doo(dead, riflemanA => false)

# Would they not be dead, given that they are not actually dead
counterfactual_dead = cond(!alt_dead, dead)

# Hint: Use sample average to approximate mean
p = prob(counterfactual_dead, 10000)

# prob ≈ 0.33
@test isapprox(p, 0.33, atol = 0.05)