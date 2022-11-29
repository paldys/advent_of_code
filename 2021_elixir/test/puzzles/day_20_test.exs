defmodule AdventOfCode.Puzzles.Day20Test do
  use ExUnit.Case

  test "parse input" do
    {algorithm, image} = load_test_image()

    assert algorithm[0] == false
    assert algorithm[511] == true

    assert image ==
             Arrays.new([
               Arrays.new([true, false, false, true, false]),
               Arrays.new([true, false, false, false, false]),
               Arrays.new([true, true, false, false, true]),
               Arrays.new([false, false, true, false, false]),
               Arrays.new([false, false, true, true, true])
             ])
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day20.solve1(load_test_image()) == 35
  end

  @tag :slow
  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day20.solve2(load_test_image()) == 3351
  end

  defp load_test_image() do
    test_input = """
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##\
    #..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###\
    .######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#.\
    .#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#.....\
    .#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#..\
    ...####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.....\
    ..##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

    #..#.
    #....
    ##..#
    ..#..
    ..###
    """

    AdventOfCode.Puzzles.Day20.parse(test_input)
  end
end
