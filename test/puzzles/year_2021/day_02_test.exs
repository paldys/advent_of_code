defmodule AdventOfCode.Puzzles.Year2021.Day02Test do
  use ExUnit.Case

  @test_input """
  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
  """

  @test_commands [
    {:forward, 5},
    {:down, 5},
    {:forward, 8},
    {:up, 3},
    {:down, 8},
    {:forward, 2}
  ]

  test "parse input" do
    assert AdventOfCode.Puzzles.Year2021.Day02.parse(@test_input) == @test_commands
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day02.solve1(@test_commands) == 150
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day02.solve2(@test_commands) == 900
  end
end
