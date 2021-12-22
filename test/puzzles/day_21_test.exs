defmodule AdventOfCode.Puzzles.Day21Test do
  use ExUnit.Case

  @test_starting_positions {4, 8}

  test "parse input" do
    test_input = """
    Player 1 starting position: 4
    Player 2 starting position: 8
    """

    assert AdventOfCode.Puzzles.Day21.parse(test_input) == @test_starting_positions
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day21.solve1(@test_starting_positions) == 739_785
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day21.solve2(nil) == nil
  end
end
