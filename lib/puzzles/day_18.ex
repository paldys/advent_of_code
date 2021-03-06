defmodule AdventOfCode.Puzzles.Day18 do
  @moduledoc """
  --- Day 18: Snailfish ---

  You descend into the ocean trench and encounter some snailfish. They say they
  saw the sleigh keys! They'll even tell you which direction the keys went if
  you help one of the smaller snailfish with his math homework.

  Snailfish numbers aren't like regular numbers. Instead, every snailfish number
  is a pair - an ordered list of two elements. Each element of the pair can be
  either a regular number or another pair.

  Pairs are written as [x,y], where x and y are the elements within the pair.
  Here are some example snailfish numbers, one snailfish number per line:

  [1,2]
  [[1,2],3]
  [9,[8,7]]
  [[1,9],[8,5]]
  [[[[1,2],[3,4]],[[5,6],[7,8]]],9]
  [[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
  [[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]

  This snailfish homework is about addition. To add two snailfish numbers, form
  a pair from the left and right parameters of the addition operator. For
  example, [1,2] + [[3,4],5] becomes [[1,2],[[3,4],5]].

  There's only one problem: snailfish numbers must always be reduced, and
  the process of adding two snailfish numbers can result in snailfish numbers
  that need to be reduced.

  To reduce a snailfish number, you must repeatedly do the first action in this
  list that applies to the snailfish number:

    - If any pair is nested inside four pairs, the leftmost such pair explodes.
    - If any regular number is 10 or greater, the leftmost such regular number
    splits.

  Once no action in the above list applies, the snailfish number is reduced.

  During reduction, at most one action applies, after which the process returns
  to the top of the list of actions. For example, if split produces a pair that
  meets the explode criteria, that pair explodes before other splits occur.

  To explode a pair, the pair's left value is added to the first regular number
  to the left of the exploding pair (if any), and the pair's right value is
  added to the first regular number to the right of the exploding pair (if any).
  Exploding pairs will always consist of two regular numbers. Then, the entire
  exploding pair is replaced with the regular number 0.

  Here are some examples of a single explode action:

    - [[[[[9,8],1],2],3],4] becomes [[[[0,9],2],3],4] (the 9 has no regular
    number to its left, so it is not added to any regular number).
    - [7,[6,[5,[4,[3,2]]]]] becomes [7,[6,[5,[7,0]]]] (the 2 has no regular
    number to its right, and so it is not added to any regular number).
    - [[6,[5,[4,[3,2]]]],1] becomes [[6,[5,[7,0]]],3].
    - [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]] becomes
    [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]] (the pair [3,2] is unaffected because
    the pair [7,3] is further to the left; [3,2] would explode
    on the next action).
    - [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]] becomes [[3,[2,[8,0]]],[9,[5,[7,0]]]].

  To split a regular number, replace it with a pair; the left element of
  the pair should be the regular number divided by two and rounded down, while
  the right element of the pair should be the regular number divided by two and
  rounded up. For example, 10 becomes [5,5], 11 becomes [5,6], 12 becomes [6,6],
  and so on.

  Here is the process of finding the reduced result of [[[[4,3],4],4],[7,[[8,4],9]]] + [1,1]:

  after addition: [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]
  after explode:  [[[[0,7],4],[7,[[8,4],9]]],[1,1]]
  after explode:  [[[[0,7],4],[15,[0,13]]],[1,1]]
  after split:    [[[[0,7],4],[[7,8],[0,13]]],[1,1]]
  after split:    [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]
  after explode:  [[[[0,7],4],[[7,8],[6,0]]],[8,1]]

  Once no reduce actions apply, the snailfish number that remains is the actual
  result of the addition operation: [[[[0,7],4],[[7,8],[6,0]]],[8,1]].

  The homework assignment involves adding up a list of snailfish numbers (your
  puzzle input). The snailfish numbers are each listed on a separate line.
  Add the first snailfish number and the second, then add that result and
  the third, then add that result and the fourth, and so on until all numbers
  in the list have been used once.

  For example, the final sum of this list is [[[[1,1],[2,2]],[3,3]],[4,4]]:

  [1,1]
  [2,2]
  [3,3]
  [4,4]

  The final sum of this list is [[[[3,0],[5,3]],[4,4]],[5,5]]:

  [1,1]
  [2,2]
  [3,3]
  [4,4]
  [5,5]

  The final sum of this list is [[[[5,0],[7,4]],[5,5]],[6,6]]:

  [1,1]
  [2,2]
  [3,3]
  [4,4]
  [5,5]
  [6,6]

  Here's a slightly larger example:

  [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
  [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
  [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
  [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
  [7,[5,[[3,8],[1,4]]]]
  [[2,[2,2]],[8,[8,1]]]
  [2,9]
  [1,[[[9,3],9],[[9,0],[0,7]]]]
  [[[5,[7,4]],7],1]
  [[[[4,2],2],6],[8,7]]

  The final sum [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]] is
  found after adding up the above snailfish numbers:

    [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
  + [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
  = [[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]

    [[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]
  + [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
  = [[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]

    [[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]
  + [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
  = [[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]

    [[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]
  + [7,[5,[[3,8],[1,4]]]]
  = [[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]

    [[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]
  + [[2,[2,2]],[8,[8,1]]]
  = [[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]

    [[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]
  + [2,9]
  = [[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]

    [[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]
  + [1,[[[9,3],9],[[9,0],[0,7]]]]
  = [[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]

    [[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]
  + [[[5,[7,4]],7],1]
  = [[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]

    [[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]
  + [[[[4,2],2],6],[8,7]]
  = [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]

  To check whether it's the right answer, the snailfish teacher only checks
  the magnitude of the final sum. The magnitude of a pair is 3 times
  the magnitude of its left element plus 2 times the magnitude of its right
  element. The magnitude of a regular number is just that number.

  For example, the magnitude of [9,1] is 3*9 + 2*1 = 29; the magnitude of [1,9]
  is 3*1 + 2*9 = 21. Magnitude calculations are recursive: the magnitude
  of [[9,1],[1,9]] is 3*29 + 2*21 = 129.

  Here are a few more magnitude examples:

      [[1,2],[[3,4],5]] becomes 143.
      [[[[0,7],4],[[7,8],[6,0]]],[8,1]] becomes 1384.
      [[[[1,1],[2,2]],[3,3]],[4,4]] becomes 445.
      [[[[3,0],[5,3]],[4,4]],[5,5]] becomes 791.
      [[[[5,0],[7,4]],[5,5]],[6,6]] becomes 1137.
      [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]] becomes 3488.

  So, given this example homework assignment:

  [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
  [[[5,[2,8]],4],[5,[[9,9],0]]]
  [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
  [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
  [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
  [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
  [[[[5,4],[7,7]],8],[[8,3],8]]
  [[9,3],[[9,9],[6,[4,9]]]]
  [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
  [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]

  The final sum is:

  [[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]

  The magnitude of this final sum is 4140.

  Add up all of the snailfish numbers from the homework assignment in the order
  they appear. What is the magnitude of the final sum?

  --- Part Two ---

  You notice a second question on the back of the homework assignment:

  What is the largest magnitude you can get from adding only two of
  the snailfish numbers?

  Note that snailfish addition is not commutative - that is, x + y and y + x
  can produce different results.

  Again considering the last example homework assignment above:

  [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
  [[[5,[2,8]],4],[5,[[9,9],0]]]
  [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
  [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
  [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
  [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
  [[[[5,4],[7,7]],8],[[8,3],8]]
  [[9,3],[[9,9],[6,[4,9]]]]
  [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
  [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]

  The largest magnitude of the sum of any two snailfish numbers in this list
  is 3993. This is the magnitude of [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
  + [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]], which reduces to
  [[[[7,8],[6,6]],[[6,0],[7,7]]],[[[7,8],[8,8]],[[7,9],[0,6]]]].

  What is the largest magnitude of any sum of two different snailfish numbers
  from the homework assignment?
  """
  def parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&parse_snailfish_number/1)
    |> Enum.map(fn {snailfish_number, _} -> snailfish_number end)
  end

  defp parse_snailfish_number(number_str) do
    case number_str do
      [?[ | rest] ->
        {left, [?, | rest]} = parse_snailfish_number(rest)
        {right, [?] | rest]} = parse_snailfish_number(rest)
        {[left, right], rest}

      [n | rest] ->
        {to_string([n]) |> String.to_integer(), rest}
    end
  end

  def solve1(numbers) do
    add_snailfish_numbers(numbers)
    |> to_magnitude()
  end

  def solve2(numbers) do
    for x <- numbers, y <- numbers do
      add_snailfish_numbers([x, y])
      |> to_magnitude()
    end
    |> Enum.max()
  end

  def add_snailfish_numbers(numbers) do
    Enum.reduce(numbers, fn number, sum ->
      reduce_number([sum, number])
    end)
  end

  defp to_magnitude([left, right]), do: 3 * to_magnitude(left) + 2 * to_magnitude(right)
  defp to_magnitude(value), do: value

  defp reduce_number(deep_number) do
    case explode_number(deep_number) do
      {:no_explosion} ->
        case split_number(deep_number) do
          {:no_split} -> deep_number
          {:split, deep_number} -> reduce_number(deep_number)
        end

      {:explosion, deep_number} ->
        reduce_number(deep_number)
    end
  end

  defp explode_number(value, depth \\ 0)

  defp explode_number(root, 0) do
    case explode_number(root, 1) do
      {:no_explosion} -> {:no_explosion}
      {_, root} -> {:explosion, root}
      {_, root, _} -> {:explosion, root}
    end
  end

  defp explode_number([left, right], 5), do: {:to_explode, 0, [left, right]}

  defp explode_number([left, right], depth) do
    case explode_number(left, depth + 1) do
      {:exploded, left} ->
        {:exploded, [left, right]}

      {:to_explode, left, [ex_left, ex_right]} ->
        {:to_explode_left, [left, explode_left_most(right, ex_right)], [ex_left]}

      {:to_explode_left, left, [ex_left]} ->
        {:to_explode_left, [left, right], [ex_left]}

      {:to_explode_right, left, [ex_right]} ->
        {:exploded, [left, explode_left_most(right, ex_right)]}

      {:no_explosion} ->
        case explode_number(right, depth + 1) do
          {:exploded, right} ->
            {:exploded, [left, right]}

          {:to_explode, right, [ex_left, ex_right]} ->
            {:to_explode_right, [explode_right_most(left, ex_left), right], [ex_right]}

          {:to_explode_left, right, [ex_left]} ->
            {:exploded, [explode_right_most(left, ex_left), right]}

          {:to_explode_right, right, [ex_right]} ->
            {:to_explode_right, [left, right], [ex_right]}

          {:no_explosion} ->
            {:no_explosion}
        end
    end
  end

  defp explode_number(_, _), do: {:no_explosion}

  defp explode_left_most(value, ex_right) do
    case value do
      [left, right] -> [explode_left_most(left, ex_right), right]
      _ -> value + ex_right
    end
  end

  defp explode_right_most(value, ex_left) do
    case value do
      [left, right] -> [left, explode_right_most(right, ex_left)]
      _ -> value + ex_left
    end
  end

  defp split_number([left, right]) do
    case split_number(left) do
      {:split, left} ->
        {:split, [left, right]}

      {:no_split} ->
        case split_number(right) do
          {:split, right} -> {:split, [left, right]}
          {:no_split} -> {:no_split}
        end
    end
  end

  defp split_number(value) when value > 9,
    do: {:split, [div(value, 2), div(value, 2) + rem(value, 2)]}

  defp split_number(_), do: {:no_split}
end
