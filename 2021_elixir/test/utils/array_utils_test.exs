defmodule AdventOfCode.Utils.ArrayUtilsTest do
  use ExUnit.Case

  alias AdventOfCode.Utils.ArrayUtils

  test "to_list keeps order of elements" do
    assert ArrayUtils.to_list(Arrays.new(1..100)) == Enum.to_list(1..100)
  end
end
