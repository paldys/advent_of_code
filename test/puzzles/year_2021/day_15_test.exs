defmodule AdventOfCode.Puzzles.Year2021.Day15Test do
  use ExUnit.Case

  @test_input """
  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581
  """

  @test_risk_levels [
    [1, 1, 6, 3, 7, 5, 1, 7, 4, 2],
    [1, 3, 8, 1, 3, 7, 3, 6, 7, 2],
    [2, 1, 3, 6, 5, 1, 1, 3, 2, 8],
    [3, 6, 9, 4, 9, 3, 1, 5, 6, 9],
    [7, 4, 6, 3, 4, 1, 7, 1, 1, 1],
    [1, 3, 1, 9, 1, 2, 8, 1, 3, 7],
    [1, 3, 5, 9, 9, 1, 2, 4, 2, 1],
    [3, 1, 2, 5, 4, 2, 1, 6, 3, 9],
    [1, 2, 9, 3, 1, 3, 8, 5, 2, 1],
    [2, 3, 1, 1, 9, 4, 4, 5, 8, 1]
  ]

  test "parse input" do
    assert AdventOfCode.Puzzles.Year2021.Day15.parse(@test_input) == @test_risk_levels
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day15.solve1(@test_risk_levels) == 40
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day15.solve2(@test_risk_levels) == 315
  end
end
