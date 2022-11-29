defmodule AdventOfCode.Utils.InputParserTest do
  use ExUnit.Case

  alias AdventOfCode.Utils.InputParser

  test "parse coma separated numbers" do
    assert InputParser.parse_comma_separated_numbers("16,1,2,0,4,2,7,1,2,14\n") == [
             16,
             1,
             2,
             0,
             4,
             2,
             7,
             1,
             2,
             14
           ]
  end

  test "parse charlists" do
    test_input = """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """

    assert InputParser.parse_charlists(test_input) == [
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
  end

  test "parse integer matrix" do
    test_input = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """

    assert InputParser.parse_integer_matrix(test_input) ==
             Arrays.new([
               Arrays.new([2, 1, 9, 9, 9, 4, 3, 2, 1, 0]),
               Arrays.new([3, 9, 8, 7, 8, 9, 4, 9, 2, 1]),
               Arrays.new([9, 8, 5, 6, 7, 8, 9, 8, 9, 2]),
               Arrays.new([8, 7, 6, 7, 8, 9, 6, 7, 8, 9]),
               Arrays.new([9, 8, 9, 9, 9, 6, 5, 6, 7, 8])
             ])
  end
end
