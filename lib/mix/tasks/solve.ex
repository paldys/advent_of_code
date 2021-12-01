defmodule Mix.Tasks.Solve do
  use Mix.Task

  alias AdventOfCode.Puzzles.Day012, as: Puzzle

  @shortdoc "Solve the puzzle"
  def run(_) do
    Puzzle.load()
    |> Puzzle.solve()
    |> IO.puts()
  end
end
