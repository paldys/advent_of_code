defmodule AdventOfCode.Puzzles.Year2021.Day21Test do
  use ExUnit.Case

  @test_starting_positions {4, 8}

  test "parse input" do
    test_input = """
    Player 1 starting position: 4
    Player 2 starting position: 8
    """

    assert AdventOfCode.Puzzles.Year2021.Day21.parse(test_input) == @test_starting_positions
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day21.solve1(@test_starting_positions) == 739_785
  end

  @tag :slow
  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day21.solve2(@test_starting_positions) == 444_356_092_776_315
  end
end
