const input = [ [ parse.(Int, split(pos, ",")) for pos ∈ split(line, " -> ") ] for line ∈ readlines("input.txt") ]

function part1()::Int
    mat = zeros(Int, 1000, 1000)
    for (sp, ep) ∈ input
        if sp == ep
            mat[sp[2]+1, sp[1]+1] += 1
        elseif sp[1] == ep[1]
            x = sp[1]
            for y ∈ sp[2]:sign(ep[2]-sp[2]):ep[2]
                mat[y+1, x+1] += 1
            end
        elseif sp[2] == ep[2]
            y = sp[2]
            for x ∈ sp[1]:sign(ep[1]-sp[1]):ep[1]
                mat[y+1, x+1] += 1
            end
        end
    end

    return count(v -> v > 1, mat)
end
println(part1())

function part2()::Int
    mat = zeros(Int, 1000, 1000)
    for (sp, ep) ∈ input
        if sp == ep
            mat[sp[2]+1, sp[1]+1] += 1
        elseif sp[1] == ep[1]
            x = sp[1]
            for y ∈ sp[2]:sign(ep[2]-sp[2]):ep[2]
                mat[y+1, x+1] += 1
            end
        elseif sp[2] == ep[2]
            y = sp[2]
            for x ∈ sp[1]:sign(ep[1]-sp[1]):ep[1]
                mat[y+1, x+1] += 1
            end
        else
            step = [sign(ep[1]-sp[1]), sign(ep[2]-sp[2])]
            cur = sp
            for _ ∈ 0:abs(sp[1]-ep[1])
                mat[cur[2]+1, cur[1]+1] += 1
                cur += step
            end
        end
    end

    return count(v -> v > 1, mat)
end
println(part2())
