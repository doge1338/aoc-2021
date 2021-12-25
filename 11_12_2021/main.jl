const w, h = (10, 10)
const input = reshape(Int.((readlines("input.txt") |> join |> collect) .- '0'), w, h)

function flash!(m::Matrix{Int64}, flashed::Vector{Tuple{Int, Int}}, x::Int, y::Int)
    m[x, y] = 0
    push!(flashed, (x, y))
    for px ∈ x-1:x+1, py ∈ y-1:y+1
        if px ∈ 1:w && py ∈ 1:h && (m[px, py] += 1) > 9
            m[px, py] += 1
            flash!(m, flashed, px, py)
        end
    end
end

function step!(m::Matrix{Int64})::Int
    m .+= 1
    flashed = Tuple{Int, Int}[]
    for x ∈ 1:w, y ∈ 1:h
        if m[x, y] > 9
            flash!(m, flashed, x, y)
        end
    end
    for (x, y) ∈ flashed
        m[x, y] = 0
    end
    return length(flashed)
end

println(#= Part 1 =# (inp -> sum(_ -> step!(inp), 1:100))(copy(input)))

function part2(inp = copy(input))::Int
    i = 0
    while true
        i += 1
        step!(inp)
        all(isequal(0), inp) && return i
    end
end
println(part2())
