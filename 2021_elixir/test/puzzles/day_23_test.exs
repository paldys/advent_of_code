defmodule AdventOfCode.Puzzles.Day23Test do
  use ExUnit.Case

  @test_initial ['BA', 'CD', 'BC', 'DA']

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

  # when running this test Day23 has to be modified to use the 2 deep room
  # configuration
  @tag :slow
  @tag timeout: :infinity
  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day23.solve1(@test_initial) == 12521
  end

  @tag :slow
  @tag timeout: :infinity
  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day23.solve2(@test_initial) == 44169
  end
end
