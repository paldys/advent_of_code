defmodule Mix.Tasks.Solve do
  use Mix.Task

  @shortdoc "Solve the puzzle"
  def run(_) do
    File.read!("resources/01-1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> AdventOfCode.Puzzles.Day012.solve()
    |> IO.puts()
  end
end
