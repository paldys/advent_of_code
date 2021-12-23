defmodule AdventOfCode.Puzzles.Day22Test do
  use ExUnit.Case

  @test_steps [
    {:on, {{10, 12}, {10, 12}, {10, 12}}},
    {:on, {{11, 13}, {11, 13}, {11, 13}}},
    {:off, {{9, 11}, {9, 11}, {9, 11}}},
    {:on, {{10, 10}, {10, 10}, {10, 10}}}
  ]

  test "parse input" do
    test_input = """
    on x=10..12,y=10..12,z=10..12
    on x=11..13,y=11..13,z=11..13
    off x=9..11,y=9..11,z=9..11
    on x=10..10,y=10..10,z=10..10
    """

    assert AdventOfCode.Puzzles.Day22.parse(test_input) == @test_steps
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day22.solve1(nil) == nil
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day22.solve2(nil) == nil
  end
end
