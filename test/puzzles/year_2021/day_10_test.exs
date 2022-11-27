defmodule AdventOfCode.Puzzles.Year2021.Day10Test do
  use ExUnit.Case

  @test_chunks [
    '[({(<(())[]>[[{[]{<()<>>',
    '[(()[<>])]({[<{<<[]>>(',
    '{([(<{}[<>[]}>{[]{[(<()>',
    '(((({<>}<{<{<>}{[]{[]{}',
    '[[<[([]))<([[{}[[()]]]',
    '[{[{({}]{}}([{[{{{}}([]',
    '{<[[]]>}<{[{[{[]{()[[[]',
    '[<(<(<(<{}))><([]([]()',
    '<{([([[(<>()){}]>(<<{{',
    '<{([{{}}[<[[[<>{}]]]>[]]'
  ]

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day10.solve1(@test_chunks) == 26397
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Year2021.Day10.solve2(@test_chunks) == 288_957
  end
end
