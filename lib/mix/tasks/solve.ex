defmodule Mix.Tasks.Solve do
  use Mix.Task

  @shortdoc "Solve the puzzle"
  def run([day, puzzle]) do
    padded_day = String.pad_leading(day, 2, "0")
    puzzle_solver_module = puzzle_solver_module(padded_day)
    Code.ensure_loaded!(puzzle_solver_module)

    puzzle_raw_input = File.read!(puzzle_input_file(padded_day))
    puzzle_input = apply(puzzle_solver_module, :parse, [puzzle_raw_input])

    puzzle_to_solve = if puzzle == "1", do: :solve1, else: :solve2

    {elapsed_time, output} = :timer.tc(puzzle_solver_module, puzzle_to_solve, [puzzle_input])

    IO.puts("Got result in #{elapsed_time / 1_000} ms:")
    IO.puts(output)
  end

  defp puzzle_solver_module(padded_day) do
    String.to_existing_atom("Elixir.AdventOfCode.Puzzles.Day#{padded_day}")
  end

  defp puzzle_input_file(padded_day) do
    "resources/day-#{padded_day}-input.txt"
  end
end
