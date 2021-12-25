const box = [ range(parse.(Int, split(s[3:end], ".."))...) for s ∈ split(readchomp("input.txt")[14:end], ", ") ]

println(#= Part 1 =# sum(1:abs(box[2][1])-1))

function part2()::Int
    return count((x, y) for x ∈ floor(Int, (sqrt(8*box[1][1])-1)/2):box[1][end], y ∈ box[2][1]:-box[2][1]) do (x, y)
        pos, vel = [0, 0], [x, y]
        for _ ∈ 1:2abs(box[2][1])
            pos += vel
            if pos[1] ∈ box[1] && pos[2] ∈ box[2]
                return true
            end
            vel -= [sign(vel[1]), 1]
        end
        return false
    end
end
println(part2())
