defmodule AdventOfCode.Utils.InputParser do
  def parse_comma_separated_numbers(input) do
    String.trim(input)
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def parse_charlists(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  def parse_integer_matrix(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn row ->
      String.codepoints(row)
      |> Enum.map(&String.to_integer/1)
      |> Arrays.new()
    end)
    |> Arrays.new()
  end
end
