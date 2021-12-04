defmodule AdventOfCode.Puzzles.Day042 do
  @moduledoc """
  On the other hand, it might be wise to try a different strategy: let the
  giant squid win.

  You aren't sure how many bingo boards a giant squid could play at once, so
  rather than waste time counting its arms, the safe thing to do is to figure
  out which board will win last and choose that one. That way, no matter which
   boards it picks, it will win for sure.

  In the above example, the second board is the last to win, which happens
  after 13 is eventually called and its middle column is completely marked. If
  you were to keep playing until this point, the second board would have a sum
  of unmarked numbers equal to 148 for a final score of 148 * 13 = 1924.

  Figure out which board will win last. Once it wins, what would its final
  score be?
  """

  alias AdventOfCode.Utils.Bingo

  def load() do
    [draw_row | board_input] =
      File.read!("resources/day-04-input.txt")
      |> String.split("\n", trim: true)

    draws =
      String.split(draw_row, ",", trim: true)
      |> Enum.map(&String.to_integer/1)

    boards =
      Enum.map(board_input, fn row ->
        String.split(row, " ", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.chunk_every(5)

    {draws, boards}
  end

  def solve({draws, boards}) do
    boards = Bingo.bingo_boards(boards)

    {last_draw, losing_board} = find_bingo_loser(draws, boards)

    last_draw *
      (List.flatten(losing_board)
       |> Enum.filter(fn {_, is_drawn} -> is_drawn == :not_drawn end)
       |> Enum.map(fn {n, _} -> n end)
       |> Enum.sum())
  end

  defp find_bingo_loser([draw | upcoming_draws], boards) do
    updated_boards = Bingo.play_bingo(draw, boards)

    losing_boards = Enum.reject(updated_boards, &Bingo.is_winning_board/1)

    case losing_boards do
      [] -> {draw, hd(updated_boards)}
      _ -> find_bingo_loser(upcoming_draws, losing_boards)
    end
  end
end
