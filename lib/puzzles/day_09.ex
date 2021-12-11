defmodule AdventOfCode.Puzzles.Day09 do
  @moduledoc """
  These caves seem to be lava tubes. Parts are even still volcanically active;
  small hydrothermal vents release smoke into the caves that slowly settles
  like rain.

  If you can model how the smoke flows through the caves, you might be able to
  avoid it and be that much safer. The submarine generates a heightmap
  of the floor of the nearby caves for you (your puzzle input).

  Smoke flows to the lowest point of the area it's in. For example, consider
  the following heightmap:

  2199943210
  3987894921
  9856789892
  8767896789
  9899965678

  Each number corresponds to the height of a particular location, where 9 is
  the highest and 0 is the lowest a location can be.

  Your first goal is to find the low points - the locations that are lower
  than any of its adjacent locations. Most locations have four adjacent
  locations (up, down, left, and right); locations on the edge or corner of
  the map have three or two adjacent locations, respectively. (Diagonal
  locations do not count as adjacent.)

  In the above example, there are four low points, all highlighted: two are
  in the first row (a 1 and a 0), one is in the third row (a 5), and one is
  in the bottom row (also a 5). All other locations on the heightmap have some
  lower adjacent location, and so are not low points.

  The risk level of a low point is 1 plus its height. In the above example,
  the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk
  levels of all low points in the heightmap is therefore 15.

  Find all of the low points on your heightmap. What is the sum of the risk
  levels of all low points on your heightmap?

  --- Part Two ---

  Next, you need to find the largest basins so you know what areas are most
  important to avoid.

  A basin is all locations that eventually flow downward to a single low point.
  Therefore, every low point has a basin, although some basins are very small.
  Locations of height 9 do not count as being in any basin, and all other
  locations will always be part of exactly one basin.

  The size of a basin is the number of locations within the basin, including
  the low point. The example above has four basins.

  The top-left basin, size 3:

  2199943210
  3987894921
  9856789892
  8767896789
  9899965678

  The top-right basin, size 9:

  2199943210
  3987894921
  9856789892
  8767896789
  9899965678

  The middle basin, size 14:

  2199943210
  3987894921
  9856789892
  8767896789
  9899965678

  The bottom-right basin, size 9:

  2199943210
  3987894921
  9856789892
  8767896789
  9899965678


  Find the three largest basins and multiply their sizes together. In the above
  example, this is 9 * 14 * 9 = 1134.

  What do you get if you multiply together the sizes of the three largest basins?

  """
  def load() do
    File.read!("resources/day-09-input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.codepoints(row)
      |> Enum.map(&String.to_integer/1)
      |> Arrays.new()
    end)
    |> Arrays.new()
  end

  def solve1(heightmap) do
    rows = Arrays.size(heightmap) - 1
    cols = Arrays.size(heightmap[0]) - 1

    for(
      x <- 0..rows,
      y <- 0..cols,
      is_local_min(heightmap, x, y, rows, cols),
      do: heightmap[x][y] + 1
    )
    |> Enum.sum()
  end

  defp is_local_min(heightmap, x, y, rows, cols) do
    (x == 0 || heightmap[x][y] < heightmap[x - 1][y]) &&
      (y == 0 || heightmap[x][y] < heightmap[x][y - 1]) &&
      (x == rows || heightmap[x][y] < heightmap[x + 1][y]) &&
      (y == cols || heightmap[x][y] < heightmap[x][y + 1])
  end

  def solve2(heightmap) do
    rows = Arrays.size(heightmap) - 1
    cols = Arrays.size(heightmap[0]) - 1

    {_, basins} =
      Enum.reduce(0..rows, {heightmap, []}, fn x, heightmap_w_basins ->
        Enum.reduce(0..cols, heightmap_w_basins, fn y, {heightmap, basins} ->
          {heightmap, basin_size} = fill_basin({heightmap, 0}, {x, y})

          case basin_size do
            0 -> {heightmap, basins}
            _ -> {heightmap, [basin_size | basins]}
          end
        end)
      end)

    Enum.sort(basins, &(&1 >= &2))
    |> Enum.take(3)
    |> Enum.product()
  end

  defp fill_basin({heightmap, size}, {x, y}) do
    if x < 0 || x == Arrays.size(heightmap) ||
         y < 0 || y == Arrays.size(heightmap[0]) ||
         heightmap[x][y] == 9 || heightmap[x][y] == -1 do
      {heightmap, size}
    else
      fill_basin({arrays_replace(heightmap, {x, y}, -1), size + 1}, {x + 1, y})
      |> fill_basin({x, y + 1})
      |> fill_basin({x - 1, y})
      |> fill_basin({x, y - 1})
    end
  end

  defp arrays_replace(md_array, {x, y}, value) do
    Arrays.replace(md_array, x, Arrays.replace(md_array[x], y, value))
  end
end
