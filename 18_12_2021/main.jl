import Base.string

mutable struct SnailfishNumber
    left::Union{SnailfishNumber, Int}
    right::Union{SnailfishNumber, Int}
    parent::Union{SnailfishNumber, Nothing}
end
function reduce!(num::SnailfishNumber)
    # damn this seemed a lot less complicated in the description
    function findnested(num::SnailfishNumber, depth::Int = 1)::Union{SnailfishNumber, Nothing}
        if num.left isa SnailfishNumber
            nested = findnested(num.left, depth+1)
            if nested !== nothing
                return nested
            end
        end
        if num.right isa SnailfishNumber
            nested = findnested(num.right, depth+1)
            if nested !== nothing
                return nested
            end
        end

        if num.left isa Int && num.right isa Int && depth > 4
            return num
        end

        return nothing
    end
    function findlarge(num::SnailfishNumber)::Union{SnailfishNumber, Nothing}
        if num.left isa Int && num.left >= 10
            return num
        end
        if num.left isa SnailfishNumber
            l = findlarge(num.left)
            if l !== nothing
                return l
            end
        end
        if num.right isa Int && num.right >= 10
            return num
        end
        if num.right isa SnailfishNumber
            r = findlarge(num.right)
            if r !== nothing
                return r
            end
        end
        return nothing
    end
    function explode!(num::SnailfishNumber)
        function add2leftmost!(sn::SnailfishNumber, n::Int)
            if sn.left isa Int
                sn.left += n
            else
                add2leftmost!(sn.left, n)
            end
        end
        function add2rightmost!(sn::SnailfishNumber, n::Int)
            if sn.right isa Int
                sn.right += n
            else
                add2rightmost!(sn.right, n)
            end
        end

        l, r = num.left, num.right
        num.left, num.right = 0, 0

        prev, cur = num, num.parent
        while cur !== nothing
            if prev == cur.left && r != 0
                if cur.right isa Int
                    cur.right += r
                else
                    add2leftmost!(cur.right, r)
                end
                r = 0
            end
            if prev == cur.right && l != 0
                if cur.left isa Int
                    cur.left += l
                else
                    add2rightmost!(cur.left, l)
                end
                l = 0
            end

            if l == 0 && r == 0
                break
            end
            prev = cur
            cur = cur.parent
        end
        if num.parent.left == num
            num.parent.left = 0
        else
            num.parent.right = 0
        end
    end
    function reducelarge!(num::SnailfishNumber)
        if num.left isa Int && num.left >= 10
            num.left = SnailfishNumber(floor(Int, num.left/2), ceil(Int, num.left/2), num)
        elseif num.right isa Int && num.right >= 10
            num.right = SnailfishNumber(floor(Int, num.right/2), ceil(Int, num.right/2), num)
        end
    end

    while true
        nested = findnested(num)
        if nested !== nothing
            explode!(nested)
            continue
        end
        large = findlarge(num)
        if large !== nothing
            reducelarge!(large)
            continue
        end
        break
    end
end
function add!(a::SnailfishNumber, b::SnailfishNumber)::SnailfishNumber
    s = SnailfishNumber(a, b, nothing)
    a.parent = s
    b.parent = s
    reduce!(s)
    return s
end
function magn(num::Union{SnailfishNumber, Int})::Int
    if num isa Int
        return num
    end
    return 3*magn(num.left)+2*magn(num.right)
end
function string(num::SnailfishNumber)::String
    return "["*string(num.left)*","*string(num.right)*"]"
end
function parsenum(str::String)::SnailfishNumber
    function parse(i::Int = 2)::Tuple{SnailfishNumber, Int}
        left, i  = if str[i] == '[' parse(i+1) else Int(str[i]-'0'), i+2 end
        right, i = if str[i] == '[' parse(i+1) else Int(str[i]-'0'), i+2 end
        s = SnailfishNumber(left, right, nothing)
        if left isa SnailfishNumber
            left.parent = s
        end
        if right isa SnailfishNumber
            right.parent = s
        end

        return s, i+1
    end
    return parse()[1]
end

const input = readlines("input.txt")

function part1()::Int
    return magn(foldl((acc, next) -> add!(acc, next), parsenum.(input[1:end])))
end
println(part1())

function part2()::Int
    return maximum(magn(add!(parsenum(a), parsenum(b))) for a ∈ input, b ∈ input if a != b)
end
println(part2())
