const input = readlines("input.txt")

function part1()::Int
    gamma = sum(Int(c > length(input)/2)*2^(12-i) for (i, c) ∈ enumerate(sum(v -> parse.(Int, collect(v)), input)))
    epsilon = gamma ⊻ (2^length(input[1])-1)

    return gamma * epsilon
end
println(part1())

function part2()::Int
    c1 = copy(input)
    c2 = copy(input)
    for bitIndex ∈ 1:length(input[1])
        if length(c1) != 1
            k = count(line -> line[bitIndex] == '1', c1) >= length(c1)/2 ? '1' : '0'
            filter!(c -> c[bitIndex] == k, c1)
        end
        if length(c2) != 1
            k = count(line -> line[bitIndex] == '1', c2) < length(c2)/2 ? '1' : '0'
            filter!(c -> c[bitIndex] == k, c2)
        end
    end
    oxygenRating = parse(Int, c1[1], base = 2)
    scrubberRating = parse(Int, c2[1], base = 2)

    return oxygenRating*scrubberRating
end
println(part2())
