const input = split(readchomp("input.txt"), "\n\n")
const winningNumbers = parse.(Int, split(input[1], ","))
const boards = [ [ parse(Int, board[15y+3x+1 : 15y+3x+2]) for x ∈ 0:4, y ∈ 0:4 ] for board ∈ input[2:end] ]

function part1()::Int
    cwn = Set{Int}()
    for num ∈ winningNumbers
        push!(cwn, num)
        for board ∈ boards
            if any(i -> all(k -> board[k, i] ∈ cwn, 1:5) || all(k -> board[i, k] ∈ cwn, 1:5), 1:5)
                return num*sum(b for b ∈ board if b ∉ cwn)
            end
        end
    end
end
println(part1())

function part2()::Int
    cwn = Set{Int}()
    boardsLeft = Set(boards)
    for num ∈ winningNumbers
        push!(cwn, num)
        for board ∈ boardsLeft
            if !any(i -> all(k -> board[k, i] ∈ cwn, 1:5) || all(k -> board[i, k] ∈ cwn, 1:5), 1:5)
                continue
            end
            if length(boardsLeft) == 1
                return num*sum(b for b ∈ board if b ∉ cwn)
            end
            delete!(boardsLeft, board)
        end
    end
end
println(part2())