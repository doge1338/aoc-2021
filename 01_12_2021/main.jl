const input = parse.(Int, readlines("input.txt"))

f(s) = count(i -> input[i-s] < input[i], 1+s:length(input))

println(#= Part 1 =# f(1))
println(#= Part 2 =# f(3))
