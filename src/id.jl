module IDS

export append, tupleid, base, combine, append, increment, defID

# # IDs
# IDs are used primarily in Omega to give identities to random variables
# Conceptually, an ID is a tuple of integers, but other data structures may be used

const TupleID = NTuple{N, Int} where N

tupleid(i::Integer) = (i,)
tupleid(i::NTuple{I, <: Integer}) where I = i

"default ID type"
defID(args...) = TupleID

# # Interface to ids

"`base(::Type{T}, i)` singleton (`i`,) of collection type `T` "
function base end

"`combine(a, b)` Combine (e.g. concatenate) `a` and `b`"
function combine end

"`append(a, b)` append `b` to the end of `a`, like `push!` but functional"
function append end

"`Increment(id::ID)` the id"
function increment end

# # Tuple id type
@inline append(a::Tuple, b::Tuple) = (a..., b...)

end