const init, input = split(readchomp("input.txt"), "\n\n")
const insrules = Dict(t[1] => t[2][1] for t ∈ split.(split(input, "\n"), " -> "))

function f(n::Int)::Int
    pairs = Dict(pair => length(collect(eachmatch(Regex(pair), init))) for pair ∈ keys(insrules))
    counts = Dict(c => 0 for c ∈ pairs |> keys |> join |> unique)

    for _ ∈ 1:n, (pair, count) ∈ copy(pairs)
        r = insrules[pair]
        pairs[pair] -= count
        pairs[pair[1]*r] += count
        pairs[r*pair[2]] += count
        counts[r] += count
    end

    return maximum(values(counts))-minimum(values(counts))
end

println(#= Part 1 =# f(10))
println(#= Part 2 =# f(40))
