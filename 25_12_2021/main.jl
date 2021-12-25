const input = begin
    lines = readlines("input.txt")
    [ lines[y][x] for x ∈ 1:length(lines[1]), y ∈ 1:length(lines) ]
end
const w, h = size(input)

function step(mat::Matrix{Char})::Matrix{Char}
    mat1 = copy(mat)
    for x ∈ 1:w, y ∈ 1:h
        if mat[x, y] == '>'
            if mat[mod1(x+1, w), y] == '.'
                mat1[mod1(x+1, w), y] = '>'
                mat1[x, y] = '.'
            else
                mat1[x, y] = '>'
            end
        end
    end
    mat2 = copy(mat1)
    for x ∈ 1:w, y ∈ 1:h
        if mat1[x, y] == 'v'
            if mat1[x, mod1(y+1, h)] == '.'
                mat2[x, mod1(y+1, h)] = 'v'
                mat2[x, y] = '.'
            else
                mat2[x, y] = 'v'
            end
        end
    end
    return mat2
end

function solve()
    cur = input
    i = 1
    while true
        next = step(cur)
        if next == cur
            return i
        end
        cur = next
        i += 1
    end
end

println(solve())
