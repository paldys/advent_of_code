defmodule AdventOfCode.Puzzles.Day24Test do
  use ExUnit.Case

  alias AdventOfCode.Puzzles.Day24

  test "parse input" do
    test_input = """
    inp a
    add a b
    mul a -2
    div a b
    mod a b
    eql a 2
    """

    assert AdventOfCode.Puzzles.Day24.parse(test_input) == [
             {:inp, :a},
             {:add, :a, :b},
             {:mul, :a, -2},
             {:div, :a, :b},
             {:mod, :a, :b},
             {:eql, :a, 2}
           ]
  end

  test "evaluate tree input" do
    assert Day24.evaluate_tree({:input}, 0, 5) == 5
  end

  test "evaluate tree previous z" do
    assert Day24.evaluate_tree({:prev, :z}, 6, 0) == 6
  end

  test "evaluate tree literal" do
    assert Day24.evaluate_tree({:literal, 7}, 0, 0) == 7
  end

  test "evaluate tree addition" do
    assert Day24.evaluate_tree({:add, {:literal, 2}, {:literal, 3}}, 0, 0) == 5
  end

  test "evaluate tree multiplication" do
    assert Day24.evaluate_tree({:mul, {:literal, 2}, {:literal, 3}}, 0, 0) == 6
  end

  test "evaluate tree division" do
    assert Day24.evaluate_tree({:div, {:literal, 15}, {:literal, 2}}, 0, 0) == 7
  end

  test "evaluate tree modulo" do
    assert Day24.evaluate_tree({:mod, {:literal, 3}, {:literal, 2}}, 0, 0) == 1
  end

  test "evaluate tree equality" do
    assert Day24.evaluate_tree({:eql, {:literal, 2}, {:literal, 3}}, 0, 0) == 0
    assert Day24.evaluate_tree({:eql, {:literal, 2}, {:literal, 2}}, 0, 0) == 1
  end

  test "evaluate tree inequality" do
    assert Day24.evaluate_tree({:neql, {:literal, 2}, {:literal, 3}}, 0, 0) == 1
    assert Day24.evaluate_tree({:neql, {:literal, 2}, {:literal, 2}}, 0, 0) == 0
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day24.solve1([
             {:inp, :w},
             {:mul, :z, 0},
             {:add, :z, :w},
             {:div, :z, 9}
           ]) == "8"
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day24.solve2([
             {:inp, :w},
             {:mul, :z, 0},
             {:add, :z, :w},
             {:mod, :z, 2}
           ]) == "2"
  end
end
