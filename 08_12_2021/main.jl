using Combinatorics

const input = map(arr -> split.(arr, " "), split.(readlines("input.txt"), " | "))

function part1()::Int
    return sum(v -> count(o -> length(o) ∈ (2, 3, 4, 7), v[2]), input)
end
println(part1())

function part2()::Int
    # slow af bruteforce solution
    # TODO: fix
    p = collect(permutations(['a', 'b', 'c', 'd', 'e', 'f', 'g']))
    nums = Dict{Vector{Int}, Int}(
        [1, 2, 3, 5, 6, 7] => 0,
        [3, 6] => 1,
        [1, 3, 4, 5, 7] => 2,
        [1, 3, 4, 6, 7] => 3,
        [2, 3, 4, 6] => 4,
        [1, 2, 4, 6, 7] => 5,
        [1, 2, 4, 5, 6, 7] => 6,
        [1, 3, 6] => 7,
        [1, 2, 3, 4, 5, 6, 7] => 8,
        [1, 2, 3, 4, 6, 7] => 9
    )

    k = 0
    for inp ∈ input
        validPermutation = Char[]
        for perm ∈ p
            valid = true
            for i ∈ inp[1]
                s = sort(map(c -> findfirst(f -> f == c, perm), collect(i)))
                if !haskey(nums, s)
                    valid = false
                    break
                end
            end
            if valid
                validPermutation = perm
                break
            end
        end
        @assert length(validPermutation) > 0

        s = ""
        for i ∈ inp[2]
            s *= string(nums[sort(map(c -> findfirst(f -> f == c, validPermutation), collect(i)))])
        end

        k += parse(Int, s)
    end

    return k
end
println(part2())
