defmodule AdventOfCode.Puzzles.Day04 do
  @moduledoc """
  You're already almost 1.5km (almost a mile) below the surface of the ocean,
  already so deep that you can't see any sunlight. What you can see, however,
  is a giant squid that has attached itself to the outside of your submarine.

  Maybe it wants to play bingo?

  Bingo is played on a set of boards each consisting of a 5x5 grid of numbers.
  Numbers are chosen at random, and the chosen number is marked on all boards
  on which it appears. (Numbers may not appear on all boards.) If all numbers
  in any row or any column of a board are marked, that board wins. (Diagonals
  don't count.)

  The submarine has a bingo subsystem to help passengers (currently, you and
  the giant squid) pass the time. It automatically generates a random order
  in which to draw numbers and a random set of boards (your puzzle input).
  For example:

  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

  22 13 17 11  0
   8  2 23  4 24
  21  9 14 16  7
   6 10  3 18  5
   1 12 20 15 19

   3 15  0  2 22
   9 18 13 17  5
  19  8  7 25 23
  20 11 10 24  4
  14 21 16 12  6

  14 21 17 24  4
  10 16 15  9 19
  18  8 23 26 20
  22 11 13  6  5
   2  0 12  3  7

  After the first five numbers are drawn (7, 4, 9, 5, and 11), there are no
  winners, but the boards are marked as follows (shown here adjacent to each
  other to save space):

  After the next six numbers are drawn (17, 23, 2, 0, 14, and 21), there are
  still no winners.

  Finally, 24 is drawn.

  At this point, the third board wins because it has at least one complete row
  or column of marked numbers (in this case, the entire top row is marked:
  14 21 17 24 4).

  The score of the winning board can now be calculated. Start by finding the
  sum of all unmarked numbers on that board; in this case, the sum is 188.
  Then, multiply that sum by the number that was just called when the board
  won, 24, to get the final score, 188 * 24 = 4512.

  To guarantee victory against the giant squid, figure out which board will
  win first. What will your final score be if you choose that board?

  --- Part Two ---

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

  def solve1({draws, boards}) do
    boards = bingo_boards(boards)

    {winning_draw, winning_board} = find_bingo_winner(draws, boards)

    winning_draw *
      (List.flatten(winning_board)
       |> Enum.filter(fn {_, is_drawn} -> is_drawn == :not_drawn end)
       |> Enum.map(fn {n, _} -> n end)
       |> Enum.sum())
  end

  defp find_bingo_winner([draw | upcoming_draws], boards) do
    updated_boards = play_bingo(draw, boards)

    winning_board = Enum.find(updated_boards, nil, &is_winning_board/1)

    if winning_board == nil do
      find_bingo_winner(upcoming_draws, updated_boards)
    else
      {draw, winning_board}
    end
  end

  def solve2({draws, boards}) do
    boards = bingo_boards(boards)

    {last_draw, losing_board} = find_bingo_loser(draws, boards)

    last_draw *
      (List.flatten(losing_board)
       |> Enum.filter(fn {_, is_drawn} -> is_drawn == :not_drawn end)
       |> Enum.map(fn {n, _} -> n end)
       |> Enum.sum())
  end

  defp find_bingo_loser([draw | upcoming_draws], boards) do
    updated_boards = play_bingo(draw, boards)

    losing_boards = Enum.reject(updated_boards, &is_winning_board/1)

    case losing_boards do
      [] -> {draw, hd(updated_boards)}
      _ -> find_bingo_loser(upcoming_draws, losing_boards)
    end
  end

  def bingo_boards(boards) do
    map_boards(boards, fn number -> {number, :not_drawn} end)
  end

  def play_bingo(draw, boards) do
    map_boards(boards, fn {n, is_drawn} ->
      if n == draw, do: {n, :drawn}, else: {n, is_drawn}
    end)
  end

  defp map_boards(boards, fun) do
    Enum.map(boards, fn board ->
      Enum.map(board, fn row ->
        Enum.map(row, fun)
      end)
    end)
  end

  def is_winning_board(board) do
    is_winning_board_horizontal(board) || is_winning_board_vertical(board)
  end

  defp is_winning_board_horizontal(board) do
    Enum.any?(board, fn row ->
      Enum.all?(row, fn {_, is_drawn} -> is_drawn == :drawn end)
    end)
  end

  defp is_winning_board_vertical(board) do
    board_width = length(hd(board))

    Enum.to_list(1..board_width)
    |> Enum.any?(fn i ->
      Enum.all?(board, fn row ->
        {_, is_drawn} = Enum.at(row, i - 1)
        is_drawn == :drawn
      end)
    end)
  end
end
