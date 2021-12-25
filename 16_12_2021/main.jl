const input = join(lpad(string(parse(Int, n, base=16), base=2), 4, '0') for n ∈ collect(readchomp("input.txt")))

struct Operation
    version::Int
    type::Int
    value::Int
    sub::Vector{Operation}
end

mutable struct Pointer
    n::Int
end

function readBITS!(ptr::Pointer)::Operation
    function rptr(n::Int)::String
        s = input[ptr.n:ptr.n+n-1]
        ptr.n += n
        return s
    end
    rptrp(n::Int) = parse(Int, rptr(n), base=2)

    version, type, value, sub = rptrp(3), rptrp(3), 0, Operation[]
    if type == 4
        while true
            bit = rptr(1)[1]
            value = value << 4 | rptrp(4)
            bit == '0' && break
        end
    elseif rptr(1)[1] == '1'
        for _ ∈ 1:rptrp(11)
            push!(sub, readBITS!(ptr))
        end
    else
        stop = ptr.n+rptrp(15)
        while ptr.n < stop
            push!(sub, readBITS!(ptr))
        end
    end

    return Operation(version, type, value, sub)
end

function part1(op::Operation = readBITS!(Pointer(1)))::Int
    return op.version + sum(part1, op.sub, init = 0)
end
println(part1())

function part2(op::Operation = readBITS!(Pointer(1)))::Int
    return [
        sum, prod, minimum, maximum, 
        (e, s) -> op.value,
        (e, s) -> e(s[1]) >  e(s[2]),
        (e, s) -> e(s[1]) <  e(s[2]),
        (e, s) -> e(s[1]) == e(s[2])
    ][op.type+1](part2, op.sub)
end
println(part2())
