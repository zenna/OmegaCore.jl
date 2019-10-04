# From Example From Causality, Page 212
using MiniOmega

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
prob(counterfactual_dead)