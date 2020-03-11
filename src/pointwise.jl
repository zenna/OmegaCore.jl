module Pointwise

using IRTools: IR, dynamo

@dynamo function omegaa(a...)
  # Pointwise pass
end

methodexists(f::Type{F}, x::Type{X}, y::Type{Y}) where {F <: Function, X, Y} =
  length(methods(F.instance, (X, Y))) > 0

# methodexists(f::Type{D}, x::Type{X}, y::Type{Y}) where {D, X, Y} =
#     length(methods(D, (X, Y))) > 0

# String(x, y)
# "adada"(x, y)

# @inline @generated function apply(f, ω)
#   if methodexists(f, ω)
#     :(f(ω))
#   else
#     :(f)
#   end
# end

# pw(f, x, y) = f(apply(x, ω), apply(y, ω))


"""
Pointwise application.

Pointwise function application gives meaning to expressions such as `x + y` 
when `x` and `y` are functions.  That is `x + y` is the function `\omega -> x(\omega) + y(\omega)`.

Pointwise works when `x` is a function but `y` is a constant, and so on.

Principle:
if x(\omega) is defined or y(\omega) is defined and f(x, y) is not defined then
do pointwise application.

Is it safe to check whether a method exists?

```
x1 = 3 + 2
x2 = pw(+, 3, 2)
@assert x1 == x2

x(ω) = unif(ω)
y = pw(+, x, 4)
```
"""
@generated function pw(f, args...)
  exists = [methodexists(ω, x) for x in args]
  if any(exists)
    wow(exist, i) = exist ? :(args[i]) : :(args[i](ω))
    [wow() for a in args]
    :(f(x, y))
  else
    :(f(args...))
  end
end

"""
Convert

```
y = x + y
y = pointwise(+, (x, y))
```

"""
function pointwise_pass()
end


end