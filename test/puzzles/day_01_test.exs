defmodule AdventOfCode.Puzzles.Day01Test do
  use ExUnit.Case

  @test_measurements [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day01.solve1(@test_measurements) == 7
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day01.solve2(@test_measurements) == 5
  end
end
