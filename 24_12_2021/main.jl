const input = readlines("input.txt")
const vars = 
    [ (split(input[i+4],  " ")[3] == "26", 
       parse(Int, split(input[i+5],  " ")[3]), 
       parse(Int, split(input[i+15], " ")[3])) for i ∈ 1:18:252 ]

function f(near::Int)::String
    digits = zeros(Int, 14)
    stack = Int[]
    for i ∈ 1:14
        if vars[i][1]
            j = pop!(stack)
            digits[j] = clamp(near - vars[j][3] - vars[i][2], 1, 9)
            digits[i] = digits[j]  + vars[j][3] + vars[i][2]
        else
            push!(stack, i)
        end
    end
    return join(digits)
end

println(#= Part 1 =# f(9))
println(#= Part 2 =# f(1))
