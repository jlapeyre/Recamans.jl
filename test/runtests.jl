using Recamans
using Test

@testset "Recamans.jl" begin
    @test length(recaman(10)) == 10
    @test numuniqe(recaman(50)) == 46
    expected_map = Dict(
    1 =>
        [20, 12, 24, 8, 1, 23, 0, 22, 6, 41, 11, 43, 9, 3, 7, 25, 13, 21, 2, 10, 18, 63, 62],
    2 => [42]
    )
    @test multmap(recaman(25)) == expected_map
end
