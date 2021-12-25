using DataStructures

const input = [ Int.(row.-'0') for row ∈ collect.(readlines("input.txt")) ]
const mat = reshape(vcat(input...), length(input[1]), length(input))
const w, h = size(mat)

function minpathlength(mat::Matrix{Int})::Int
    w, h = size(mat)
    dists = zeros(Int, w, h) .- 1
    dists[1, 1] = 0
    queue = PriorityQueue((1, 1) => 0)

    while true
        x, y = dequeue!(queue)

        for (px, py) ∈ [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]
            if get(dists, (px, py), 0) == -1
                dists[px, py] = dists[x, y] + mat[px, py]
                enqueue!(queue, (px, py), dists[px, py])
            end
        end

        if dists[w, h] != -1
            return dists[w, h]
        end
    end
end

println(#= Part 1 =# minpathlength(mat))
println(#= Part 2 =# minpathlength([ (mat[x%w+1, y%h+1] + x÷w + y÷h - 1)%9 + 1 for x ∈ 0:5w-1, y ∈ 0:5h-1 ]))
