defmodule AdventOfCode.Puzzles.Day06Test do
  use ExUnit.Case

  @test_timers [3, 4, 3, 1, 2]

  test "solve puzzle for 18" do
    assert AdventOfCode.Puzzles.Day06.solve1(@test_timers, 18) == 26
  end

  test "solve puzzle for 80" do
    assert AdventOfCode.Puzzles.Day06.solve1(@test_timers) == 5934
  end
end
