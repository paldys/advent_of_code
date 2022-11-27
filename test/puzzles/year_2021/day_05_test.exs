defmodule AdventOfCode.Puzzles.Year2021.Day05Test do
  use ExUnit.Case

  @test_input """
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
  """

  @test_lines [
    {{0, 9}, {5, 9}},
    {{8, 0}, {0, 8}},
    {{9, 4}, {3, 4}},
    {{2, 2}, {2, 1}},
    {{7, 0}, {7, 4}},
    {{6, 4}, {2, 0}},
    {{0, 9}, {2, 9}},
    {{3, 4}, {1, 4}},
    {{0, 0}, {8, 8}},
    {{5, 5}, {8, 2}}
  ]

  test "parse input" do
    assert AdventOfCode.Puzzles.Year2021.Day05.parse(@test_input) == @test_lines
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day05.solve1(@test_lines) == 5
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day05.solve2(@test_lines) == 12
  end
end
