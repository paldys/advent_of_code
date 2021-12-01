defmodule AdventOfCode.Puzzles.Day011Test do
  use ExUnit.Case

  test "solve example" do
    measurements = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
    assert AdventOfCode.Puzzles.Day011.solve(measurements) == 7
  end
end
