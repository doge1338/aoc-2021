function decomp(stream::IOStream)
    for op ∈ input
        fn, args... = split(op, " ")

        if fn == "inp"
            println(stream, "\n\n$(args[1]) = input()")
        elseif fn == "add"
            println(stream, "$(args[1]) += $(args[2])")
        elseif fn == "mul"
            println(stream, "$(args[1]) *= $(args[2])")
        elseif fn == "div"
            println(stream, "$(args[1]) /= $(args[2])")
        elseif fn == "mod"
            println(stream, "$(args[1]) %= $(args[2])")
        elseif fn == "eql"
            println(stream, "$(args[1]) = $(args[1]) == $(args[2]) ? 1 : 0")
        else
            error(fn)
        end
    end
end



function verify(id::String)::Bool
    @assert length(id) == 14

    # z is a base 26 number, it has to end up with 0 for the id to be valid
    z = 0
    for (i, c) ∈ enumerate(id)
        w = Int(c-'0')

        x = z%26 + vars[i][2]
        # vars[i][1] is true for half of the digits
        if vars[i][1]
            z ÷= 26
        end
        # if vars[i][1] is false this has to be true
        if x != w
            z = 26z + w + vars[i][3]
        end
    end
    
    return z == 0
end
