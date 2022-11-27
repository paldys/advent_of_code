defmodule AdventOfCode.Puzzles.Year2021.Day11Test do
  use ExUnit.Case

  @test_energy_levels Arrays.new([
                        Arrays.new([5, 4, 8, 3, 1, 4, 3, 2, 2, 3]),
                        Arrays.new([2, 7, 4, 5, 8, 5, 4, 7, 1, 1]),
                        Arrays.new([5, 2, 6, 4, 5, 5, 6, 1, 7, 3]),
                        Arrays.new([6, 1, 4, 1, 3, 3, 6, 1, 4, 6]),
                        Arrays.new([6, 3, 5, 7, 3, 8, 5, 4, 7, 8]),
                        Arrays.new([4, 1, 6, 7, 5, 2, 4, 6, 4, 5]),
                        Arrays.new([2, 1, 7, 6, 8, 4, 1, 7, 2, 1]),
                        Arrays.new([6, 8, 8, 2, 8, 8, 1, 1, 3, 4]),
                        Arrays.new([4, 8, 4, 6, 8, 4, 8, 5, 5, 4]),
                        Arrays.new([5, 2, 8, 3, 7, 5, 1, 5, 2, 6])
                      ])

  test "solve 1st puzzle for 10 steps" do
    assert AdventOfCode.Puzzles.Year2021.Day11.solve1(@test_energy_levels, 10) == 204
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day11.solve1(@test_energy_levels) == 1656
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day11.solve2(@test_energy_levels) == 195
  end
end
