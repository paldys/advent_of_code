defmodule AdventOfCode.Puzzles.Day021 do
  @moduledoc """
  It seems like the submarine can take a series of commands like forward 1,
  down 2, or up 3:

      forward X increases the horizontal position by X units.
      down X increases the depth by X units.
      up X decreases the depth by X units.

  Note that since you're on a submarine, down and up affect your depth, and so
  they have the opposite result of what you might expect.

  The submarine seems to already have a planned course (your puzzle input). You
  should probably figure out where it's going. For example:

  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2

  Your horizontal position and depth both start at 0. The steps above would
  then modify them as follows:

      forward 5 adds 5 to your horizontal position, a total of 5.
      down 5 adds 5 to your depth, resulting in a value of 5.
      forward 8 adds 8 to your horizontal position, a total of 13.
      up 3 decreases your depth by 3, resulting in a value of 2.
      down 8 adds 8 to your depth, resulting in a value of 10.
      forward 2 adds 2 to your horizontal position, a total of 15.

  After following these instructions, you would have a horizontal position
  of 15 and a depth of 10. (Multiplying these together produces 150.)

  Calculate the horizontal position and depth you would have after following
  the planned course. What do you get if you multiply your final horizontal
  position by your final depth?
  """
  @spec load() :: [{:forward | :down | :up, integer()}]
  def load() do
    File.read!("resources/02-1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn row -> String.split(row, " ") end)
    |> Enum.map(fn [command_str, units_str] ->
      {String.to_existing_atom(command_str), String.to_integer(units_str)}
    end)
  end

  def solve(commands) do
    {position, depth} =
      List.foldl(commands, {0, 0}, fn {command, units}, {position, depth} ->
        case command do
          :forward -> {position + units, depth}
          :down -> {position, depth + units}
          :up -> {position, depth - units}
        end
      end)

    position * depth
  end
end