defmodule AdventOfCode.Utils.Loader do
  def load_comma_separated_numbers(file_name) do
    File.read!(file_name)
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def load_charlists(file_name) do
    File.read!(file_name)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end
end
