defmodule AdventOfCode.Puzzles.Day15 do
  @moduledoc """
  --- Day 15: Chiton ---

  You've almost reached the exit of the cave, but the walls are getting closer
  together. Your submarine can barely still fit, though; the main problem is
  that the walls of the cave are covered in chitons, and it would be best not
  to bump any of them.

  The cavern is large, but has a very low ceiling, restricting your motion
  to two dimensions. The shape of the cavern resembles a square; a quick scan
  of chiton density produces a map of risk level throughout the cave (your
  puzzle input). For example:

  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581

  You start in the top left position, your destination is the bottom right
  position, and you cannot move diagonally. The number at each position is its
  risk level; to determine the total risk of an entire path, add up the risk
  levels of each position you enter (that is, don't count the risk level of
  your starting position unless you enter it; leaving it adds no risk to your
  total).

  Your goal is to find a path with the lowest total risk. In this example,
  a path with the lowest total risk is highlighted here:

  *1 1 6 3 7 5 1 7 4 2
  *1 3 8 1 3 7 3 6 7 2
  *2*1*3*6*5*1*1 3 2 8
   3 6 9 4 9 3*1*5 6 9
   7 4 6 3 4 1 7*1 1 1
   1 3 1 9 1 2 8 1*3 7
   1 3 5 9 9 1 2 4*2 1
   3 1 2 5 4 2 1 6*3 9
   1 2 9 3 1 3 8 5*2*1
   2 3 1 1 9 4 4 5 8*1

  The total risk of this path is 40 (the starting position is never entered,
  so its risk is not counted).

  What is the lowest total risk of any path from the top left to the bottom
  right?

  """
  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn row ->
      String.codepoints(row)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def solve1(risk_levels) do
    find_safest_path(risk_levels)
  end

  def solve2(risk_levels) do
    duplicated_to_right =
      Enum.map(risk_levels, fn risk_levels_line ->
        Enum.flat_map(0..4, fn i ->
          Enum.map(risk_levels_line, fn risk ->
            rem(risk - 1 + i, 9) + 1
          end)
        end)
      end)

    duplicated_to_bottom =
      Enum.flat_map(0..4, fn i ->
        Enum.map(duplicated_to_right, fn risk_levels_line ->
          Enum.map(risk_levels_line, fn risk ->
            rem(risk - 1 + i, 9) + 1
          end)
        end)
      end)

    find_safest_path(duplicated_to_bottom)
  end

  defp find_safest_path(
         [[current_risk | rest_in_line] | rest],
         mapped_paths \\ %{},
         x \\ 0,
         y \\ 0
       ) do
    safest_path =
      if x == 0 && y == 0 do
        0
      else
        safest_path_from_known_neighbors(mapped_paths, x, y) + current_risk
      end

    updated_paths = Map.put(mapped_paths, {x, y}, {current_risk, safest_path})

    updated_paths =
      Enum.reduce(known_neighbors(x, y), updated_paths, fn {x, y}, updated_paths ->
        update_old_paths(updated_paths, x, y, safest_path)
      end)

    cond do
      rest == [] && rest_in_line == [] -> safest_path
      rest_in_line == [] -> find_safest_path(rest, updated_paths, 0, y + 1)
      true -> find_safest_path([rest_in_line | rest], updated_paths, x + 1, y)
    end
  end

  defp safest_path_from_known_neighbors(mapped_paths, x, y) do
    Enum.filter(known_neighbors(x, y), &Map.has_key?(mapped_paths, &1))
    |> Enum.map(fn xy -> Map.get(mapped_paths, xy) end)
    |> Enum.map(fn {_, safest_path} -> safest_path end)
    |> Enum.min()
  end

  defp known_neighbors(x, y) do
    [{x - 1, y}, {x, y - 1}]
  end

  defp update_old_paths(mapped_paths, x, y, safest_path) do
    case Map.get(mapped_paths, {x, y}) do
      {risk, old_safest_path} when safest_path + risk < old_safest_path ->
        Map.put(mapped_paths, {x, y}, {risk, safest_path + risk})
        |> update_old_paths(x - 1, y, safest_path + risk)
        |> update_old_paths(x, y - 1, safest_path + risk)
        |> update_old_paths(x + 1, y, safest_path + risk)
        |> update_old_paths(x, y + 1, safest_path + risk)

      _ ->
        mapped_paths
    end
  end
end
