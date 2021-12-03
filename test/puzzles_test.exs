defmodule AdventOfCode.PuzzlesTest do
  use ExUnit.Case

  @day_01_test_input [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

  test "day 01-1 puzzle" do
    assert AdventOfCode.Puzzles.Day011.solve(@day_01_test_input) == 7
  end

  test "day 01-2 puzzle" do
    assert AdventOfCode.Puzzles.Day012.solve(@day_01_test_input) == 5
  end

  @day_02_test_input [{:forward, 5}, {:down, 5}, {:forward, 8}, {:up, 3}, {:down, 8}, {:forward, 2}]

  test "day 02-1 puzzle" do
    assert AdventOfCode.Puzzles.Day021.solve(@day_02_test_input) == 150
  end

  test "day 02-2 puzzle" do
    assert AdventOfCode.Puzzles.Day022.solve(@day_02_test_input) == 900
  end

  @day_03_test_input [
    '00100',
    '11110',
    '10110',
    '10111',
    '10101',
    '01111',
    '00111',
    '11100',
    '10000',
    '11001',
    '00010',
    '01010'
  ]

  test "day 03-1 puzzle" do
    assert AdventOfCode.Puzzles.Day031.solve(@day_03_test_input) == 198
  end

  test "day 03-2 puzzle" do
    assert AdventOfCode.Puzzles.Day032.solve(@day_03_test_input) == 230
  end
end
