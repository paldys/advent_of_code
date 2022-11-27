defmodule AdventOfCode.Puzzles.Year2021.Day19Test do
  use ExUnit.Case

  test "parse input" do
    test_input = """
    --- scanner 0 ---
    0,2
    4,1
    3,3

    --- scanner 1 ---
    -1,-1
    -5,0
    -2,1
    """

    assert AdventOfCode.Puzzles.Year2021.Day19.parse(test_input) == [
             [[3, 3], [4, 1], [0, 2]],
             [[-2, 1], [-5, 0], [-1, -1]]
           ]
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day19.solve1(load_test_report()) == 79
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day19.solve2(load_test_report()) == 3621
  end

  defp load_test_report() do
    File.read!("resources/year-2021/day-19-test-input.txt")
    |> AdventOfCode.Puzzles.Year2021.Day19.parse()
  end
end
