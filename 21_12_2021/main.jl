const s1, s2 = (parse(Int, s[29:end]) for s ∈ readlines("input.txt"))

function part1()::Int
    c1, c2 = s1, s2
    n1, n2 = 0, 0
    i = 0
    while true
        n1 += c1 = (c1+9i+5)%10 + 1
        i += 1
        n1 >= 1000 && break
        n2 += c2 = (c2+9i+5)%10 + 1
        i += 1
        n2 >= 1000 && break
    end
    return min(n1, n2)*3i
end
println(part1())

function part2()::Int
    weights = [0, 0, 1, 3, 6, 7, 6, 3, 1]
    cache = Dict{Int32, Vector{Int}}()
    function recur(c1, c2, n1, n2, diceroll, turn)
        args = Int32((c1 << 18) | (c2 << 14) | (n1 << 9) | (n2 << 4) | ((diceroll-3) << 1) | turn)
        if haskey(cache, args)
            return cache[args]
        end
        
        turn == 0 && (n1 += c1 = (c1+diceroll-1)%10+1) >= 21 && return [1, 0]
        turn == 1 && (n2 += c2 = (c2+diceroll-1)%10+1) >= 21 && return [0, 1]

        return cache[args] = sum(n -> weights[n]*recur(c1, c2, n1, n2, n, (turn+1)%2), 3:9)
    end
    res = sum(n -> weights[n]*recur(s1, s2, 0, 0, n, 0), 3:9)
    
    return max(res[1], res[2])
end
println(part2())
