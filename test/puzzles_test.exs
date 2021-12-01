defmodule AdventOfCode.PuzzlesTest do
  use ExUnit.Case

  test "day 01-1 puzzle" do
    measurements = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
    assert AdventOfCode.Puzzles.Day011.solve(measurements) == 7
  end
end
