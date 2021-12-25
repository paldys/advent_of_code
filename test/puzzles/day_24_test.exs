defmodule AdventOfCode.Puzzles.Day24Test do
  use ExUnit.Case

  test "parse input" do
    test_input = """
    inp a
    add a b
    mul a -2
    div a b
    mod a b
    eql 2 b
    """

    assert AdventOfCode.Puzzles.Day24.parse(test_input) == [
      {:inp, :a},
      {:add, :a, :b},
      {:mul, :a, -2},
      {:div, :a, :b},
      {:mod, :a, :b},
      {:eql, 2, :b}
    ]
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day24.solve1(nil) == nil
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day24.solve2(nil) == nil
  end
end
