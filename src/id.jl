# # ID
const TupleID = NTuple{N, Int} where N

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
@inline append(a::Tuple, b) = (a..., b)