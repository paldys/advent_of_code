defmodule AdventOfCode.PuzzlesTest do
  use ExUnit.Case

  test "day 01-1 puzzle" do
    measurements = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
    assert AdventOfCode.Puzzles.Day011.solve(measurements) == 7
  end

  test "day 01-2 puzzle" do
    measurements = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
    assert AdventOfCode.Puzzles.Day012.solve(measurements) == 5
  end

  test "day 02-1 puzzle" do
    commands = [{:forward, 5}, {:down, 5}, {:forward, 8}, {:up, 3}, {:down, 8}, {:forward, 2}]
    assert AdventOfCode.Puzzles.Day021.solve(commands) == 150
  end

  test "day 02-2 puzzle" do
    commands = [{:forward, 5}, {:down, 5}, {:forward, 8}, {:up, 3}, {:down, 8}, {:forward, 2}]
    assert AdventOfCode.Puzzles.Day022.solve(commands) == 900
  end

  test "day 03-1 puzzle" do
    codes = ['00100', '11110', '10110', '10111', '10101', '01111', '00111', '11100', '10000', '11001', '00010', '01010']
    assert AdventOfCode.Puzzles.Day031.solve(codes) == 198
  end
end
