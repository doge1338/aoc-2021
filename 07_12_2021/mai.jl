const input = parse.(Int, split(readchomp("input.txt"), ","))

f(costfn) = minimum(n -> sum(p -> costfn(abs(p-n)), input), 0:maximum(input))

println(#= Part 1 =# f(x -> x))
println(#= Part 2 =# f(x -> sum(1:x)))
