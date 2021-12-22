defmodule AdventOfCode.Utils.ArrayUtils do
  @doc """
  For some reason Arrays.to_list() doesn't keep the order of elements.
  This implementation should keep it.
  """
  def to_list(array) do
    size = Arrays.size(array)

    for x <- 0..(size - 1) do
      array[x]
    end
  end
end
