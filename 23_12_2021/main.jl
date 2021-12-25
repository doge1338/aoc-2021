const input = begin
    l = readlines("input.txt")
    [
        [l[3][4]  - 'A' + 1, l[4][4]  - 'A' + 1],
        [l[3][6]  - 'A' + 1, l[4][6]  - 'A' + 1],
        [l[3][8]  - 'A' + 1, l[4][8]  - 'A' + 1],
        [l[3][10] - 'A' + 1, l[4][10] - 'A' + 1],
    ]
end

const realpos = [1, 2, 4, 6, 8, 10, 11]
const bucketpos = [3, 5, 7, 9]

function f(input)::Int
    cache = Dict{Tuple{Int, Int}, Int}()
    function recur(buckets::Vector{Vector{Int}}, corridor::Vector{Int}, min::Int = -1)::Int
        # hashing arrays can be expensive so instead pack everything into 2 integers
        args = (
            (buckets[1][1] << 0)  | (buckets[1][2] << 3)  | (get(buckets[1], 3, 0) << 6)  | (get(buckets[1], 4, 0) << 9)  |
            (buckets[2][1] << 12) | (buckets[2][2] << 15) | (get(buckets[2], 3, 0) << 18) | (get(buckets[2], 4, 0) << 21) |
            (buckets[2][1] << 24) | (buckets[2][2] << 27) | (get(buckets[2], 3, 0) << 30) | (get(buckets[2], 4, 0) << 33) |
            (buckets[2][1] << 36) | (buckets[2][2] << 39) | (get(buckets[2], 3, 0) << 42) | (get(buckets[2], 4, 0) << 45),
            (corridor[1]) | (corridor[2] << 3) | (corridor[3] << 6) | (corridor[4] << 9) | (corridor[5] << 12) | (corridor[6] << 15) | (corridor[7] << 18)
        )
        if haskey(cache, args)
            return cache[args]
        end

        # Move all possible fish from corridors to buckets.
        # a move from corridor to bucket can unlock other moves like that, iterate until no more moves are possible
        score::Int = 0
        cont = true
        while cont
            cont = false
            for (i, b) ∈ enumerate(buckets)
                b[1] != 0 && continue
                any(v -> v ∉ (i, 0), b) && continue
                depth = count(isequal(0), b)

                # left
                for j ∈ i+1:-1:1
                    corridor[j] == 0 && continue
                    if corridor[j] == i
                        b[depth] = corridor[j]
                        corridor[j] = 0
                        score += (depth+abs(bucketpos[i]-realpos[j])) * 10^(i-1)
                        cont = true
                    end
                    break
                end
                cont && break

                # right
                for j ∈ i+2:7
                    corridor[j] == 0 && continue
                    if corridor[j] == i
                        b[depth] = corridor[j]
                        corridor[j] = 0
                        score += (depth+abs(bucketpos[i]-realpos[j])) * 10^(i-1)
                        cont = true
                    end
                    break
                end
                cont && break
            end
        end
        if min != -1 && score >= min
            return cache[args] = -1
        end
        if all(i -> all(isequal(i), buckets[i]), 1:4)
            return cache[args] = score
        end

        # Check for all possible moves from buckets to corridors
        Move = NamedTuple{(:cost, :bucket, :depth, :place), NTuple{4, Int64}}
        moves = Move[]
        for (i, b) ∈ enumerate(buckets)
            b[end] == 0 && continue
            all(v -> v ∈ (i, 0), b) && continue
            depth = count(isequal(0), b) + 1

            # left
            for j ∈ i+1:-1:1
                corridor[j] != 0 && break
                push!(moves, (cost = (depth+abs(bucketpos[i]-realpos[j]))*10^(b[depth]-1), bucket = i, depth = depth, place = j))
            end
            # right
            for j ∈ i+2:7
                corridor[j] != 0 && break
                push!(moves, (cost = (depth+abs(bucketpos[i]-realpos[j]))*10^(b[depth]-1), bucket = i, depth = depth, place = j))
            end
        end

        min = -1
        ncorridor = [0, 0, 0, 0, 0, 0, 0]
        nbuckets = length(buckets[1]) == 2 ? [[0, 0], [0, 0], [0, 0], [0, 0]] : [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
        for move ∈ moves
            copyto!(ncorridor, corridor)
            copyto!(nbuckets[1], buckets[1])
            copyto!(nbuckets[2], buckets[2])
            copyto!(nbuckets[3], buckets[3])
            copyto!(nbuckets[4], buckets[4])

            ncorridor[move.place] = nbuckets[move.bucket][move.depth]
            nbuckets[move.bucket][move.depth] = 0
            nmin = recur(nbuckets, ncorridor, min)
            if nmin != -1
                nmin += move.cost
                if nmin != -1 && (min == -1 || nmin < min)
                    min = nmin
                end
            end
        end
        if min == -1
            return cache[args] = -1
        end
        return cache[args] = score+min
    end

    return recur(input, [0, 0, 0, 0, 0, 0, 0])
end

println(#= Part 1 =# f(input))
println(#= Part 2 =# f([ 
    [ input[1][1], 4, 4, input[1][2] ],
    [ input[2][1], 3, 2, input[2][2] ],
    [ input[3][1], 2, 1, input[3][2] ], 
    [ input[4][1], 1, 3, input[4][2] ] 
]))
