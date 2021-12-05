defmodule AdventOfCode.Puzzles.Day02Test do
  use ExUnit.Case

  @test_commands [
    {:forward, 5},
    {:down, 5},
    {:forward, 8},
    {:up, 3},
    {:down, 8},
    {:forward, 2}
  ]

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day02.solve1(@test_commands) == 150
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day02.solve2(@test_commands) == 900
  end
end
