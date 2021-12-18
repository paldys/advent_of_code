defmodule AdventOfCode.Utils.Loader do
  alias AdventOfCode.Utils.InputParser

  def load_comma_separated_numbers(file_name) do
    File.read!(file_name)
    |> InputParser.parse_comma_separated_numbers()
  end

  def load_charlists(file_name) do
    File.read!(file_name)
    |> InputParser.parse_charlists()
  end

  def load_integer_matrix(file_name) do
    File.read!(file_name)
    |> InputParser.parse_integer_matrix()
  end
end
