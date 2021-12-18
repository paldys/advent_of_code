defmodule AdventOfCode.Puzzles.Day18Test do
  use ExUnit.Case

  @test_input """
  [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
  [[[5,[2,8]],4],[5,[[9,9],0]]]
  [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
  [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
  [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
  [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
  [[[[5,4],[7,7]],8],[[8,3],8]]
  [[9,3],[[9,9],[6,[4,9]]]]
  [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
  [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
  """

  @test_snailfish_numbers [
    [[[0, [5, 8]], [[1, 7], [9, 6]]], [[4, [1, 2]], [[1, 4], 2]]],
    [[[5, [2, 8]], 4], [5, [[9, 9], 0]]],
    [6, [[[6, 2], [5, 6]], [[7, 6], [4, 7]]]],
    [[[6, [0, 7]], [0, 9]], [4, [9, [9, 0]]]],
    [[[7, [6, 4]], [3, [1, 3]]], [[[5, 5], 1], 9]],
    [[6, [[7, 3], [3, 2]]], [[[3, 8], [5, 7]], 4]],
    [[[[5, 4], [7, 7]], 8], [[8, 3], 8]],
    [[9, 3], [[9, 9], [6, [4, 9]]]],
    [[2, [[7, 7], 7]], [[5, 8], [[9, 3], [0, 2]]]],
    [[[[5, 2], 5], [8, [3, 7]]], [[5, [7, 5]], [4, 4]]]
  ]

  test "parse input" do
    assert AdventOfCode.Puzzles.Day18.parse(@test_input) == @test_snailfish_numbers
  end

  test "add snailfish numbers" do
    assert AdventOfCode.Puzzles.Day18.add_snailfish_numbers([[1, 1], [2, 2], [3, 3], [4, 4]]) ==
             [[[[1, 1], [2, 2]], [3, 3]], [4, 4]]

    assert AdventOfCode.Puzzles.Day18.add_snailfish_numbers([
             [1, 1],
             [2, 2],
             [3, 3],
             [4, 4],
             [5, 5]
           ]) == [[[[3, 0], [5, 3]], [4, 4]], [5, 5]]

    assert AdventOfCode.Puzzles.Day18.add_snailfish_numbers([
             [1, 1],
             [2, 2],
             [3, 3],
             [4, 4],
             [5, 5],
             [6, 6]
           ]) == [[[[5, 0], [7, 4]], [5, 5]], [6, 6]]

    assert AdventOfCode.Puzzles.Day18.add_snailfish_numbers([
             [[[0, [4, 5]], [0, 0]], [[[4, 5], [2, 6]], [9, 5]]],
             [7, [[[3, 7], [4, 3]], [[6, 3], [8, 8]]]],
             [[2, [[0, 8], [3, 4]]], [[[6, 7], 1], [7, [1, 6]]]],
             [[[[2, 4], 7], [6, [0, 5]]], [[[6, 8], [2, 8]], [[2, 1], [4, 5]]]],
             [7, [5, [[3, 8], [1, 4]]]],
             [[2, [2, 2]], [8, [8, 1]]],
             [2, 9],
             [1, [[[9, 3], 9], [[9, 0], [0, 7]]]],
             [[[5, [7, 4]], 7], 1],
             [[[[4, 2], 2], 6], [8, 7]]
           ]) == [[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]]
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day18.solve1(@test_snailfish_numbers) == 4140
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day18.solve2(nil) == nil
  end
end
