const emap, inputimg = (((m, img),) -> ([ c == '#' for c ∈ m ], split(img, "\n")))(split(readchomp("input.txt"), "\n\n"))
const w, h = length(inputimg[1]), length(inputimg)

const mw = 300
const image = [ x ∈ mw÷2+1:mw÷2+w && y ∈ mw÷2+1:mw÷2+h && inputimg[y-mw÷2][x-mw÷2] == '#' for x ∈ 1:mw, y ∈ 1:mw ]

step(image, fill) = 
    [ emap[sum(get(image, (x+rx, y+ry), fill) << (4-3ry-rx) for rx ∈ -1:1, ry ∈ -1:1)+1] for x ∈ 1:mw, y ∈ 1:mw ], fill != emap[1]

function f(n::Int)::Int
    cur, fill = image, false
    for _ ∈ 1:n
        cur, fill = step(cur, fill)
    end
    return count(cur)
end

println(#= Part 1 =# f(2))
println(#= Part 2 =# f(50))
