defmodule AdventOfCode.Puzzles.Year2021.Day17Test do
  use ExUnit.Case

  @test_target_area {{20, 30}, {-10, -5}}

  test "parse input" do
    assert AdventOfCode.Puzzles.Year2021.Day17.parse("target area: x=20..30, y=-10..-5\n") ==
             {{20, 30}, {-10, -5}}
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day17.solve1(@test_target_area) == 45
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day17.solve2(@test_target_area) == 112
  end
end
