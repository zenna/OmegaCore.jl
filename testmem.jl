using Profile
using Cassette
function t1(n)
    for i = 1:n
        rand()
    end
end
Cassette.@context TestCtx
const t = TestCtx()
Cassette.overdub(t, t1, 1)
@profile @time Cassette.overdub(t, t1, 10000)
Profile.print()