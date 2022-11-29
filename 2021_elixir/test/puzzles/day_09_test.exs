defmodule AdventOfCode.Puzzles.Day09Test do
  use ExUnit.Case

  @test_heightmap Arrays.new([
                    Arrays.new([2, 1, 9, 9, 9, 4, 3, 2, 1, 0]),
                    Arrays.new([3, 9, 8, 7, 8, 9, 4, 9, 2, 1]),
                    Arrays.new([9, 8, 5, 6, 7, 8, 9, 8, 9, 2]),
                    Arrays.new([8, 7, 6, 7, 8, 9, 6, 7, 8, 9]),
                    Arrays.new([9, 8, 9, 9, 9, 6, 5, 6, 7, 8])
                  ])

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day09.solve1(@test_heightmap) == 15
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day09.solve2(@test_heightmap) == 1134
  end
end
