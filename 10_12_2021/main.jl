const input = collect.(readlines("input.txt"))

const symbols = Dict{Char, Char}('(' => ')', '[' => ']', '{' => '}', '<' => '>')

function part1()::Int
    scores = Dict{Char, Int}(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
    points = 0
    for line ∈ input
        stack = Char[]
        for char ∈ line
            if haskey(symbols, char)
                push!(stack, char)
                continue
            end
            if char != symbols[last(stack)]
                points += scores[char]
                break
            end
            pop!(stack)
        end
    end
    return points
end
println(part1())

function part2()::Int
    scores = Dict{Char, Int}('(' => 1, '[' => 2, '{' => 3, '<' => 4)
    points = Int[]
    for line ∈ input
        stack = Char[]
        valid = true
        for char ∈ line
            if haskey(symbols, char)
                push!(stack, char)
                continue
            end
            if char != symbols[last(stack)]
                valid = false
                break
            end
            pop!(stack)
        end
        if valid
            push!(points, sum(n -> 5^(n-1)*scores[stack[n]], 1:length(stack)))
        end
    end
    return sort(points)[ceil(Int, length(points)/2)]
end
println(part2())
