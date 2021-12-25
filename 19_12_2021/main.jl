const input = [ sort([ tuple(parse.(Int, s)...) for s ∈ split.(split(scanner, "\n")[2:end], ",") ], by = v -> sum(abs(c) for c ∈ v)) 
    for scanner ∈ split(readchomp("input.txt"), "\n\n") ]

const Vec3 = Tuple{Int, Int, Int}

const orientations = Vec3[
    (+1, +2, +3), (+1, +3, -2), (+1, -2, -3), (+1, -3, +2),
    (-1, +2, -3), (-1, -3, -2), (-1, -2, +3), (-1, +3, +2),
    (+2, -1, +3), (+2, +3, +1), (+2, +1, -3), (+2, -3, -1),
    (-2, +1, +3), (-2, +3, -1), (-2, -1, -3), (-2, -3, +1),
    (+3, +2, -1), (+3, -1, -2), (+3, -2, +1), (+3, +1, +2),
    (-3, +2, +1), (-3, +1, -2), (-3, -2, -1), (-3, -1, +2),
]
transform(pos, n) = Vec3(sign(o)*pos[abs(o)] for o ∈ orientations[n])

# this is hacky af and i'm pretty sure it only works by accident but at least it works lmao
const scanners = Vec3[]
struct Scanner
    idx::Int
    intersects::Vector{Scanner}
end
function makemap(idx::Int, offset::Vec3, rotation::Int, scanned::Set{Int} = Set{Int}())::Scanner
    push!(scanners, offset)
    for i ∈ 1:length(ninput[idx])
        ninput[idx][i] = transform(ninput[idx][i], rotation)
        ninput[idx][i] = ninput[idx][i] .+ offset
    end

    scanner = Scanner(idx, Scanner[])
    push!(scanned, idx)
    ts = ninput[idx]
    for (i, cs) ∈ enumerate(ninput[1:end])
        i ∈ scanned && continue

        for pos1 ∈ ts, pos2 ∈ cs, n ∈ 1:24
            off = pos1 .- transform(pos2, n)
            c = count(cp -> transform(cp, n) .+ off ∈ ts, cs)
            if c >= 12
                push!(scanner.intersects, makemap(i, off, n, scanned))
                break
            end
        end
    end
    return scanner
end
getbeacons(sc) = unique([ ninput[sc.idx]; ( getbeacons(int) for int ∈ sc.intersects )... ])

const beacons = getbeacons(makemap(1, (0, 0, 0), 1))

println(#= Part 1 =# length(beacons))

println(#= Part 2 =# maximum(sum(abs, b1.-b2) for b1 ∈ scanners for b2 ∈ scanners))
