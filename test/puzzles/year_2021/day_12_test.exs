defmodule AdventOfCode.Puzzles.Year2021.Day12Test do
  use ExUnit.Case

  @test_input """
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
  """

  @test_lines_small [
    {"start", "A"},
    {"start", "b"},
    {"A", "c"},
    {"A", "b"},
    {"b", "d"},
    {"A", "end"},
    {"b", "end"}
  ]

  @test_lines_medium [
    {"dc", "end"},
    {"HN", "start"},
    {"start", "kj"},
    {"dc", "start"},
    {"dc", "HN"},
    {"LN", "dc"},
    {"HN", "end"},
    {"kj", "sa"},
    {"kj", "HN"},
    {"kj", "dc"}
  ]

  @test_lines_large [
    {"fs", "end"},
    {"he", "DX"},
    {"fs", "he"},
    {"start", "DX"},
    {"pj", "DX"},
    {"end", "zg"},
    {"zg", "sl"},
    {"zg", "pj"},
    {"pj", "he"},
    {"RW", "he"},
    {"fs", "DX"},
    {"pj", "RW"},
    {"zg", "RW"},
    {"start", "pj"},
    {"he", "WI"},
    {"zg", "he"},
    {"pj", "fs"},
    {"start", "RW"}
  ]

  test "parse input" do
    assert AdventOfCode.Puzzles.Year2021.Day12.parse(@test_input) == @test_lines_small
  end

  test "solve 1st puzzle for small" do
    assert AdventOfCode.Puzzles.Year2021.Day12.solve1(@test_lines_small) == 10
  end

  test "solve 1st puzzle for medium" do
    assert AdventOfCode.Puzzles.Year2021.Day12.solve1(@test_lines_medium) == 19
  end

  test "solve 1st puzzle for large" do
    assert AdventOfCode.Puzzles.Year2021.Day12.solve1(@test_lines_large) == 226
  end

  test "solve 2nd puzzle for small" do
    assert AdventOfCode.Puzzles.Year2021.Day12.solve2(@test_lines_small) == 36
  end

  test "solve 2nd puzzle for medium" do
    assert AdventOfCode.Puzzles.Year2021.Day12.solve2(@test_lines_medium) == 103
  end

  test "solve 2nd puzzle for large" do
    assert AdventOfCode.Puzzles.Year2021.Day12.solve2(@test_lines_large) == 3509
  end
end
