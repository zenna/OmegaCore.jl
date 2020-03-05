# # Tags

"A value `val` tagged with data `tag`"
struct Tagged{T, NT}
  val::T
  tag::NT
end

"tag the value `val` with tag `tag`"
tag(val, tag) = Tagged(val, tag)

const TAG{T, NT} = Union{T, Tagged{T, NT}}

"Copy tags from `t1` to `t2`"
copytag(t1, t2) = Tagged(t2, t1.tag)
copytag(t1, t2::Tagged) = error("t2 has tags, implement this")

# Named Tuple stuff

"""

```
x = (a = 3, b = 4, c =12)
rmkeys(tag, :x, :y)
```
"""
@generated function rmkeys(tag::NamedTuple{K, V}, keys...) where {K, V}
  Core.println(keys)
  args = [:($k = tag.$k) for k in K if k ∉ keys]
  ok = Expr(:tuple, args...)
  Core.println(ok)
  ok
end

function rmkeys2(tag::NamedTuple{K, V}, keys...) where {K, V}
  
end