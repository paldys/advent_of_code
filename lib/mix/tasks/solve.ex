defmodule Mix.Tasks.Solve do
  use Mix.Task

  @shortdoc "Solve the puzzle"
  def run(args) do
    puzzle_solver_module = puzzle_solver_module(args)
    Code.ensure_loaded!(puzzle_solver_module)

    puzzle_input = apply(puzzle_solver_module, :load, [])
    apply(puzzle_solver_module, :solve, [puzzle_input])
    |> IO.puts()
  end

  defp puzzle_solver_module([day, puzzle]) do
    String.to_existing_atom("Elixir.AdventOfCode.Puzzles.Day#{String.pad_leading(day, 2, "0")}#{puzzle}")
  end
end
