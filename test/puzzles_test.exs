defmodule AdventOfCode.PuzzlesTest do
  use ExUnit.Case

  @day_01_test_input [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

  test "day 01-1 puzzle" do
    assert AdventOfCode.Puzzles.Day011.solve(@day_01_test_input) == 7
  end

  test "day 01-2 puzzle" do
    assert AdventOfCode.Puzzles.Day012.solve(@day_01_test_input) == 5
  end

  @day_02_test_input [
    {:forward, 5},
    {:down, 5},
    {:forward, 8},
    {:up, 3},
    {:down, 8},
    {:forward, 2}
  ]

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

  @day_04_test_draws [
    7,
    4,
    9,
    5,
    11,
    17,
    23,
    2,
    0,
    14,
    21,
    24,
    10,
    16,
    13,
    6,
    15,
    25,
    12,
    22,
    18,
    20,
    8,
    19,
    3,
    26,
    1
  ]

  @day_04_test_boards [
    [
      [22, 13, 17, 11, 0],
      [8, 2, 23, 4, 24],
      [21, 9, 14, 16, 7],
      [6, 10, 3, 18, 5],
      [1, 12, 20, 15, 19]
    ],
    [
      [3, 15, 0, 2, 22],
      [9, 18, 13, 17, 5],
      [19, 8, 7, 25, 23],
      [20, 11, 10, 24, 4],
      [14, 21, 16, 12, 6]
    ],
    [
      [14, 21, 17, 24, 4],
      [10, 16, 15, 9, 19],
      [18, 8, 23, 26, 20],
      [22, 11, 13, 6, 5],
      [2, 0, 12, 3, 7]
    ]
  ]

  test "day 04-1 puzzle" do
    assert AdventOfCode.Puzzles.Day041.solve({@day_04_test_draws, @day_04_test_boards}) == 4512
  end

  test "day 04-2 puzzle" do
    assert AdventOfCode.Puzzles.Day042.solve({@day_04_test_draws, @day_04_test_boards}) == 1924
  end
end
