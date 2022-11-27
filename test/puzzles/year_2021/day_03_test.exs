defmodule AdventOfCode.Puzzles.Year2021.Day03Test do
  use ExUnit.Case

  @test_codes [
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

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day03.solve1(@test_codes) == 198
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day03.solve2(@test_codes) == 230
  end
end
