const lines = readlines("input.txt")
const w, h = length(lines[1]), length(lines)
const input = [ Int(lines[y][x]-'0') for x ∈ 1:w, y ∈ 1:h ]

const nb = [(0, -1), (0, 1), (-1, 0), (1, 0)]

const lowpoints = Set((x, y) for x ∈ 1:w, y ∈ 1:h if all(get(input, (x+px, y+py), 9) > input[x, y] for (px, py) ∈ nb))

println(#= Part 1 =# sum(p -> input[p...]+1, lowpoints))

function part2()::Int
    unchecked = ones(Bool, w, h)
    function checkpoint(x, y)
        unchecked[x, y] = false
        return 1 + sum((checkpoint(x+px, y+py) for (px, py) ∈ nb if get(unchecked, (x+px, y+py), false) && input[x+px, y+py] != 9), init = 0)
    end
    return prod(sort([ checkpoint(x, y) for (x, y) ∈ lowpoints ], rev=true)[1:3])
end
println(part2())
