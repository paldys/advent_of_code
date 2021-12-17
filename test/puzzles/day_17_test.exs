defmodule AdventOfCode.Puzzles.Day17Test do
  use ExUnit.Case

  @test_target_area {{20, 30}, {-10, -5}}

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day17.solve1(@test_target_area) == 45
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day17.solve2(nil) == nil
  end
end
