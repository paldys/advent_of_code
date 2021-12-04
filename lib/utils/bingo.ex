defmodule AdventOfCode.Utils.Bingo do
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
