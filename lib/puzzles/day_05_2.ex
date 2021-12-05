defmodule AdventOfCode.Puzzles.Day052 do
  @moduledoc """
  Unfortunately, considering only horizontal and vertical lines doesn't give
  you the full picture; you need to also consider diagonal lines.

  Because of the limits of the hydrothermal vent mapping system, the lines
  in your list will only ever be horizontal, vertical, or a diagonal line at
  exactly 45 degrees. In other words:

      An entry like 1,1 -> 3,3 covers points 1,1, 2,2, and 3,3.
      An entry like 9,7 -> 7,9 covers points 9,7, 8,8, and 7,9.

  Considering all lines from the above example would now produce the following
  diagram:

  1.1....11.
  .111...2..
  ..2.1.111.
  ...1.2.2..
  .112313211
  ...1.2....
  ..1...1...
  .1.....1..
  1.......1.
  222111....

  You still need to determine the number of points where at least two lines
  overlap. In the above example, this is still anywhere in the diagram with
  a 2 or larger - now a total of 12 points.

  Consider all of the lines. At how many points do at least two lines overlap?
  """

  def load() do
    AdventOfCode.Puzzles.Day051.load()
  end

  def solve(lines) do
    Enum.map(lines, &expand_lines/1)
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.count(fn {_, frequency} -> frequency > 1 end)
  end

  defp expand_lines({{x, y1}, {x, y2}}) when y1 > y2 do
    expand_lines({{x, y2}, {x, y1}})
  end

  defp expand_lines({{x, y1}, {x, y2}}) do
    Enum.to_list(y1..y2)
    |> Enum.map(fn y -> {x, y} end)
  end

  defp expand_lines({{x1, y}, {x2, y}}) when x1 > x2 do
    expand_lines({{x2, y}, {x1, y}})
  end

  defp expand_lines({{x1, y}, {x2, y}}) do
    Enum.to_list(x1..x2)
    |> Enum.map(fn x -> {x, y} end)
  end

  defp expand_lines({{x1, y1}, {x2, y2}}) do
    Enum.zip(Enum.to_list(x1..x2), Enum.to_list(y1..y2))
  end
end
