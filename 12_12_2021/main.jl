const input = split.(readlines("input.txt"), "-")

const caves = Set(vcat(input...))
const connections = Dict(name => String[] for name ∈ caves)
for (a, b) ∈ input
    push!(connections[a], b)
    push!(connections[b], a)
end

function findpaths!(vt::Bool, vsc::Vector{String} = String[], cave::String = "start")::Int
    cave == "end" && return 1
    issmall = cave[1] ∈ 'a':'z' && cave[2] ∈ 'a':'z'

    issmall && push!(vsc, cave)
    count = sum(connections[cave], init = 0) do conn
        if conn ∉ vsc
            findpaths!(vt, vsc, conn)
        elseif !vt && conn != "start"
            findpaths!(true, vsc, conn)
        else 0 end
    end
    issmall && pop!(vsc)
    
    return count
end

println(#= Part 1 =# findpaths!(true))
println(#= Part 2 =# findpaths!(false))
