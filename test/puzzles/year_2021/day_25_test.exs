defmodule AdventOfCode.Puzzles.Year2021.Day25Test do
  use ExUnit.Case

  @initial_state Arrays.new([
                   Arrays.new([?v, ?., ?., ?., ?>, ?>, ?., ?v, ?v, ?>]),
                   Arrays.new([?., ?v, ?v, ?>, ?>, ?., ?v, ?v, ?., ?.]),
                   Arrays.new([?>, ?>, ?., ?>, ?v, ?>, ?., ?., ?., ?v]),
                   Arrays.new([?>, ?>, ?v, ?>, ?>, ?., ?>, ?., ?v, ?.]),
                   Arrays.new([?v, ?>, ?v, ?., ?v, ?v, ?., ?v, ?., ?.]),
                   Arrays.new([?>, ?., ?>, ?>, ?., ?., ?v, ?., ?., ?.]),
                   Arrays.new([?., ?v, ?v, ?., ?., ?>, ?., ?>, ?v, ?.]),
                   Arrays.new([?v, ?., ?v, ?., ?., ?>, ?>, ?v, ?., ?v]),
                   Arrays.new([?., ?., ?., ?., ?v, ?., ?., ?v, ?., ?>])
                 ])

  test "parse input" do
    test_input = """
    v...>>.vv>
    .vv>>.vv..
    >>.>v>...v
    >>v>>.>.v.
    v>v.vv.v..
    >.>>..v...
    .vv..>.>v.
    v.v..>>v.v
    ....v..v.>
    """

    assert AdventOfCode.Puzzles.Year2021.Day25.parse(test_input) == @initial_state
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day25.solve1(@initial_state) == 58
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day25.solve2(nil) == nil
  end
end
