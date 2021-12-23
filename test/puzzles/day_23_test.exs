defmodule AdventOfCode.Puzzles.Day23Test do
  use ExUnit.Case

  @test_initial [[?B, ?A], [?C, ?D], [?B, ?C], [?D, ?A]]

  test "parse input" do
    test_input = """
    #############
    #...........#
    ###B#C#B#D###
      #A#D#C#A#
      #########
    """

    assert AdventOfCode.Puzzles.Day23.parse(test_input) == @test_initial
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day23.solve1(nil) == nil
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day23.solve2(nil) == nil
  end
end
