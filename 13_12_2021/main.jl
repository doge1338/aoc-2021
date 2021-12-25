const input = split.(split(readchomp("input.txt"), "\n\n"), "\n")
const marks = [ tuple(parse.(Int, split(pos, ","))...) .+ 1    for pos  ∈ input[1] ]
const folds = [ (fold[12], parse(Int, fold[14:end])) for fold ∈ input[2] ]
const w, h = maximum(c -> c[1], marks), maximum(c -> c[2], marks)

function foldmatrix(m::Matrix{Bool}, axis::Char, i::Int)::Matrix{Bool}
    w, h = size(m)
    return axis == 'x' ?
        [ m[x, y] || 2i+2-x <= w && m[2i+2-x, y] for x ∈ 1:i, y ∈ 1:h ] :
        [ m[x, y] || 2i+2-y <= h && m[x, 2i+2-y] for x ∈ 1:w, y ∈ 1:i ]
end
function printMatrix(m::Matrix{Bool})
    w, h = size(m)
    println("\n", join([ join([ m[x, y] ? "█" : " " for x ∈ 1:w ]) * "\n" for y ∈ 1:h ]))
end

println(#= Part 1 =# count(foldmatrix([ (x, y) ∈ marks for x ∈ 1:w, y ∈ 1:h ], folds[1]...)))

printMatrix(#= Part 2 =# foldl((mat, fold) -> foldmatrix(mat, fold...), folds, init = [ (x, y) ∈ marks for x ∈ 1:w, y ∈ 1:h ]))
