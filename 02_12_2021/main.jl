const input = [ (split(v, " ")[1], parse(Int, split(v, " ")[2])) for v ∈ readlines("input.txt") ]

println(#= Part 1 =# prod(sum(i -> [i[1] == "forward" ? i[2] : 0, i[1] == "down" ? i[2] : i[1] == "up" ? -i[2] : 0], input)))

function part2()::Int
    position = 0
    depth = 0
    aim = 0
    for (instruction, value) ∈ input
        if instruction == "forward"
            position += value
            depth += aim*value
        elseif instruction == "down"
            aim += value
        elseif instruction == "up"
            aim -= value
        end
    end

    return position*depth
end
println(part2())

