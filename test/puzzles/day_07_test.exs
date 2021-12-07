defmodule AdventOfCode.Puzzles.Day07Test do
  use ExUnit.Case

  @test_positions [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day07.solve1(@test_positions) == 37
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day07.solve2(@test_positions) == 168
  end
end
