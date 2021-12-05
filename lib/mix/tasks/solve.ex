defmodule Mix.Tasks.Solve do
  use Mix.Task

  @shortdoc "Solve the puzzle"
  def run([day, puzzle]) do
    puzzle_solver_module = puzzle_solver_module(day)
    Code.ensure_loaded!(puzzle_solver_module)

    puzzle_input = apply(puzzle_solver_module, :load, [])

    puzzle_to_solve = if puzzle == "1", do: :solve1, else: :solve2

    apply(puzzle_solver_module, puzzle_to_solve, [puzzle_input])
    |> IO.puts()
  end

  defp puzzle_solver_module(day) do
    String.to_existing_atom("Elixir.AdventOfCode.Puzzles.Day#{String.pad_leading(day, 2, "0")}")
  end
end
