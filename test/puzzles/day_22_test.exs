defmodule AdventOfCode.Puzzles.Day22Test do
  use ExUnit.Case

  @test_steps_small [
    {:on, {{10, 12}, {10, 12}, {10, 12}}},
    {:on, {{11, 13}, {11, 13}, {11, 13}}},
    {:off, {{9, 11}, {9, 11}, {9, 11}}},
    {:on, {{10, 10}, {10, 10}, {10, 10}}}
  ]

  @test_steps_medium [
    {:on, {{-20, 26}, {-36, 17}, {-47, 7}}},
    {:on, {{-20, 33}, {-21, 23}, {-26, 28}}},
    {:on, {{-22, 28}, {-29, 23}, {-38, 16}}},
    {:on, {{-46, 7}, {-6, 46}, {-50, -1}}},
    {:on, {{-49, 1}, {-3, 46}, {-24, 28}}},
    {:on, {{2, 47}, {-22, 22}, {-23, 27}}},
    {:on, {{-27, 23}, {-28, 26}, {-21, 29}}},
    {:on, {{-39, 5}, {-6, 47}, {-3, 44}}},
    {:on, {{-30, 21}, {-8, 43}, {-13, 34}}},
    {:on, {{-22, 26}, {-27, 20}, {-29, 19}}},
    {:off, {{-48, -32}, {26, 41}, {-47, -37}}},
    {:on, {{-12, 35}, {6, 50}, {-50, -2}}},
    {:off, {{-48, -32}, {-32, -16}, {-15, -5}}},
    {:on, {{-18, 26}, {-33, 15}, {-7, 46}}},
    {:off, {{-40, -22}, {-38, -28}, {23, 41}}},
    {:on, {{-16, 35}, {-41, 10}, {-47, 6}}},
    {:off, {{-32, -23}, {11, 30}, {-14, 3}}},
    {:on, {{-49, -5}, {-3, 45}, {-29, 18}}},
    {:off, {{18, 30}, {-20, -8}, {-3, 13}}},
    {:on, {{-41, 9}, {-7, 43}, {-33, 15}}},
    {:on, {{-54112, -39298}, {-85059, -49293}, {-27449, 7877}}},
    {:on, {{967, 23432}, {45373, 81175}, {27513, 53682}}}
  ]

  test "parse input" do
    test_input = """
    on x=10..12,y=10..12,z=10..12
    on x=11..13,y=11..13,z=11..13
    off x=9..11,y=9..11,z=9..11
    on x=10..10,y=10..10,z=10..10
    """

    assert AdventOfCode.Puzzles.Day22.parse(test_input) == @test_steps_small
  end

  test "overlapping cubes" do
    assert AdventOfCode.Puzzles.Day22.is_overlapping({{0, 5}}, {{0, 5}})
    assert AdventOfCode.Puzzles.Day22.is_overlapping({{0, 5}}, {{-1, 5}})
    assert AdventOfCode.Puzzles.Day22.is_overlapping({{0, 5}}, {{1, 5}})
    assert AdventOfCode.Puzzles.Day22.is_overlapping({{0, 5}}, {{0, 4}})
    assert AdventOfCode.Puzzles.Day22.is_overlapping({{0, 5}}, {{0, 6}})
    assert AdventOfCode.Puzzles.Day22.is_overlapping({{0, 2}}, {{2, 4}})
    assert AdventOfCode.Puzzles.Day22.is_overlapping({{2, 4}}, {{0, 2}})
    assert AdventOfCode.Puzzles.Day22.is_overlapping({{0, 0}}, {{0, 2}})
    assert AdventOfCode.Puzzles.Day22.is_overlapping({{1, 3}}, {{2, 2}})
    refute AdventOfCode.Puzzles.Day22.is_overlapping({{0, 0}}, {{1, 2}})
    refute AdventOfCode.Puzzles.Day22.is_overlapping({{1, 2}}, {{-1, 0}})
  end

  test "substract cubes" do
    left = {{1, 3}, {1, 3}, {1, 3}}
    right = {{2, 2}, {2, 2}, {2, 2}}

    expected = [
      {{1, 1}, {1, 3}, {1, 3}},
      {{3, 3}, {1, 3}, {1, 3}},
      {{2, 2}, {1, 1}, {1, 3}},
      {{2, 2}, {3, 3}, {1, 3}},
      {{2, 2}, {2, 2}, {1, 1}},
      {{2, 2}, {2, 2}, {3, 3}}
    ]

    assert AdventOfCode.Puzzles.Day22.substract(left, right) == expected
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day22.solve1(@test_steps_small) == 39
    assert AdventOfCode.Puzzles.Day22.solve1(@test_steps_medium) == 590_784
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day22.solve2(nil) == nil
  end
end
