const input = [ (state == "on", tuple([ range(parse.(Int, split(comp[3:end], ".."))...) for comp ∈ split(rg, ",") ]...)) 
    for (state, rg) ∈ split.(readlines("input.txt"), " ") ]

const Cuboid = Tuple{UnitRange{Int}, UnitRange{Int}, UnitRange{Int}}

volume(a::Cuboid) = prod(length, a)
intersection(a::Cuboid, b::Cuboid) = 
    intersect(a[1], b[1]), intersect(a[2], b[2]), intersect(a[3], b[3])
without(a::Cuboid, int::Cuboid) = 
    filter(v -> volume(v) != 0, [
        # floor/ceiling
        (a[1], a[2], a[3][1]:int[3][1]-1),
        (a[1], a[2], int[3][end]+1:a[3][end]),
        # along y (with edges)
        (a[1][1]:int[1][1]-1,     a[2], int[3]),
        (int[1][end]+1:a[1][end], a[2], int[3]),
        # along x (without edges)
        (int[1], a[2][1]:int[2][1]-1,     int[3]),
        (int[1], int[2][end]+1:a[2][end], int[3]),
    ])

function f(input)
    cuboids = Cuboid[]
    for (ison, cuboid) ∈ input
        for i ∈ 1:length(cuboids)
            i > length(cuboids) && break

            int = intersection(cuboids[i], cuboid)
            volume(int) === 0 && continue

            w = without(cuboids[i], int)
            if length(w) > 0
                cuboids[i] = w[1]
                push!(cuboids, w[2:end]...)
            else
                cuboids[i] = pop!(cuboids)
            end
        end
        if ison
            push!(cuboids, cuboid)
        end
    end
    return sum(volume, cuboids)
end

println(#= Part 1 =# f(inp for inp ∈ input if all(inp[2][i] ⊆ -50:50 for i ∈ 1:3)))
println(#= Part 2 =# f(input))
