const input = [ count(isequal(n), parse.(Int, split(readchomp("input.txt"), ","))) for n ∈ 0:8 ]
const m = [ x-1 == y || x == 1 && y ∈ (7, 9) for y ∈ 1:9, x ∈ 1:9 ]

f(n) = sum(m^n * input)

println(#= Part 1 =# f(80))
println(#= Part 2 =# f(256))
