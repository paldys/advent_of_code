defmodule AdventOfCode.Puzzles.Year2021.Day13Test do
  use ExUnit.Case

  @test_input """
  6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0

  fold along y=7
  fold along x=5
  """

  @test_dots [
    {6, 10},
    {0, 14},
    {9, 10},
    {0, 3},
    {10, 4},
    {4, 11},
    {6, 0},
    {6, 12},
    {4, 1},
    {0, 13},
    {10, 12},
    {3, 4},
    {3, 0},
    {8, 4},
    {1, 10},
    {2, 14},
    {8, 10},
    {9, 0}
  ]

  @test_instructions [
    {:horizontal, 7},
    {:vertical, 5}
  ]

  test "parse input" do
    assert AdventOfCode.Puzzles.Year2021.Day13.parse(@test_input) == {@test_dots, @test_instructions}
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day13.solve1({@test_dots, @test_instructions}) == 17
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day13.solve2({@test_dots, @test_instructions}) == """
           #####
           #...#
           #...#
           #...#
           #####\
           """
  end
end
