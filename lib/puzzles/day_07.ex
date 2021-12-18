defmodule AdventOfCode.Puzzles.Day07 do
  @moduledoc """
  --- Day 7: The Treachery of Whales ---

  A giant whale has decided your submarine is its next meal, and it's much
  faster than you are. There's nowhere to run!

  Suddenly, a swarm of crabs (each in its own tiny submarine - it's too deep
  for them otherwise) zooms in to rescue you! They seem to be preparing to
  blast a hole in the ocean floor; sensors indicate a massive underground cave
  system just beyond where they're aiming!

  The crab submarines all need to be aligned before they'll have enough power
  to blast a large enough hole for your submarine to get through. However, it
  doesn't look like they'll be aligned before the whale catches you! Maybe you
  can help?

  There's one major catch - crab submarines can only move horizontally.

  You quickly make a list of the horizontal position of each crab (your puzzle
  input). Crab submarines have limited fuel, so you need to find a way to make
  all of their horizontal positions match while requiring them to spend as
  little fuel as possible.

  For example, consider the following horizontal positions:

  16,1,2,0,4,2,7,1,2,14

  This means there's a crab with horizontal position 16, a crab with horizontal
  position 1, and so on.

  Each change of 1 step in horizontal position of a single crab costs 1 fuel.
  You could choose any horizontal position to align them all on, but the one
  that costs the least fuel is horizontal position 2:

      Move from 16 to 2: 14 fuel
      Move from 1 to 2: 1 fuel
      Move from 2 to 2: 0 fuel
      Move from 0 to 2: 2 fuel
      Move from 4 to 2: 2 fuel
      Move from 2 to 2: 0 fuel
      Move from 7 to 2: 5 fuel
      Move from 1 to 2: 1 fuel
      Move from 2 to 2: 0 fuel
      Move from 14 to 2: 12 fuel

  This costs a total of 37 fuel. This is the cheapest possible outcome; more
  expensive outcomes include aligning at position 1 (41 fuel), position 3
  (39 fuel), or position 10 (71 fuel).

  Determine the horizontal position that the crabs can align to using the
  least fuel possible. How much fuel must they spend to align to that position?

  --- Part Two ---

  The crabs don't seem interested in your proposed solution. Perhaps you
  misunderstand crab engineering?

  As it turns out, crab submarine engines don't burn fuel at a constant rate.
  Instead, each change of 1 step in horizontal position costs 1 more unit of
  fuel than the last: the first step costs 1, the second step costs 2, the
  third step costs 3, and so on.

  As each crab moves, moving further becomes more expensive. This changes the
  best horizontal position to align them all on; in the example above, this
  becomes 5:

      Move from 16 to 5: 66 fuel
      Move from 1 to 5: 10 fuel
      Move from 2 to 5: 6 fuel
      Move from 0 to 5: 15 fuel
      Move from 4 to 5: 1 fuel
      Move from 2 to 5: 6 fuel
      Move from 7 to 5: 3 fuel
      Move from 1 to 5: 10 fuel
      Move from 2 to 5: 6 fuel
      Move from 14 to 5: 45 fuel

  This costs a total of 168 fuel. This is the new cheapest possible outcome;
  the old alignment position (2) now costs 206 fuel instead.

  Determine the horizontal position that the crabs can align to using the least
  fuel possible so they can make you an escape route! How much fuel must they
  spend to align to that position?
  """

  alias AdventOfCode.Utils.InputParser

  def parse(input) do
    InputParser.parse_comma_separated_numbers(input)
  end

  @doc """
  Let p1, p2, p3, ... pn be the position of the crabs. Let q be the end
  position. The function whose minimum we are looking for is:

  abs(p1 - q) + abs(p2 - q) + abs(p3 - q) + ... + abs(pn - q)

  Where q is an integer and q >= 0. Let's group the number of crabs
  at each positions and sort them.

  1  2  3  0  1  0  0  1  0  0  0  0  0  0  1  0  1  0     -- number of crabs
  |- |- |- |- |- |- |- |- |- |- |- |- |- |- |- |- |- |- ...
  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17     -- position

  ^0
  At zero, the consumption is exactly the sum of each position, i.e. 49. Now,
  let's keep track of two values, let's call them 'below' and 'over'. 'below'
  will track the number of crabs below or equal our position, that means
  for 0 it will be 1. 'over' will be the number of crabs above this position
  and that is 9.

     ^1
  At 1, we will get a position away from 1 crab (the value 'below') and we will
  get closer to 9 crabs (the value 'over'). i.e. the new value using the previous
  compution will be: 49 + 1 - 9 = 41
  The new 'below' value will be 3 and the new 'over' value will be 7

        ^2
  At 2, we will get a position away from 3 crabs and get closer to 7 crabs. So,
  again we can calculate the new consumption from the previous value:
  41 + 3 - 7 = 37

  And so on...

  """
  def solve1(positions) do
    most_efficient1(positions)
  end

  defp most_efficient1(positions) do
    grouped_positions = group_and_sort(positions)
    consumption = distance_from_zero(grouped_positions)
    number_of_crabs = number_of_crabs(grouped_positions)

    find_most_efficient1(grouped_positions, 0, consumption, 0, number_of_crabs)
  end

  defp find_most_efficient1(
         positions,
         at_position,
         prev_consumption,
         below,
         over
       ) do
    {positions, below, over} =
      case positions do
        [{^at_position, count} | rest_positions] ->
          {rest_positions, below + count, over - count}

        _ ->
          {positions, below, over}
      end

    case prev_consumption + below - over do
      consumption when prev_consumption < consumption ->
        prev_consumption

      consumption ->
        find_most_efficient1(
          positions,
          at_position + 1,
          consumption,
          below,
          over
        )
    end
  end

  @doc """
  Let's use the same notations as for the first puzzle of the day. Also let
  x1 = abs(p1 - q), x2 = abs(p2 - q), ... xn = abs(pn - q)

  i.e. xn is the distance of the nth crab from q. The consumption of a single
  crab can be calculated by the following formula:

    xn * (xn + 1) / 2

  Let's now subsitute xn = |pn - q| into this formula:

    abs(pn - q) * (abs(pn - q) + 1) / 2
    (abs(pn - q) * abs(pn - q) + abs(pn - q)) / 2
    (pn * pn - 2 * pn * q + q * q + abs(pn - q)) / 2

  As it is visible the function whose minimum we are looking for will look:

  (p1 * p1 + p2 * p2* + ... - 2 * q * (p1 + p2 + ...) + n * q * q +
                  + abs(p1 - q) + abs(p2 - q) + ... + abs(pn - q)) / 2

  There are a few constants in this formula, that we can remove to simplify it
  (since we are looking for its minimum, they won't influence it):

  - 2 * q * (p1 + p2 + ...) + n * q * q + abs(p1 - q) + abs(p2 - q) + ...
  | --------- 1 --------- |  | -- 2 -- |  | ----------- 3 ------------ |

  Let's discuss each part of this formula:
   1. The first part is fairly easy to compute for any q because the sum of
      each position is a constant. We can just increase q and get the number
   2. The second part is easy too. Just increasing q and n is a constant (the
      number of crabs)
   3. The third part is doable the same way as the first puzzle was solved. So,
      we only need to combine in the rest.
  """
  def solve2(positions) do
    most_efficient2(positions)
  end

  defp most_efficient2(positions) do
    grouped_positions = group_and_sort(positions)
    simple_consumption = distance_from_zero(grouped_positions)
    squared_consumption = sqr_distance_from_zero(grouped_positions)
    number_of_crabs = number_of_crabs(grouped_positions)

    find_most_efficient2(
      grouped_positions,
      0,
      simple_consumption,
      simple_consumption,
      0,
      number_of_crabs,
      number_of_crabs,
      simple_consumption,
      squared_consumption
    )
  end

  defp find_most_efficient2(
         positions,
         at_position,
         prev_simple_consumption,
         prev_var_consumption,
         below,
         over,
         position_count,
         position_sum,
         position_squared_sum
       ) do
    var_consumption =
      prev_simple_consumption + position_count * at_position * at_position -
        2 * at_position * position_sum

    {positions, below, over} =
      case positions do
        [{^at_position, count} | rest_positions] ->
          {rest_positions, below + count, over - count}

        _ ->
          {positions, below, over}
      end

    simple_consumption = prev_simple_consumption + below - over

    if prev_var_consumption < var_consumption do
      div(prev_var_consumption + position_squared_sum, 2)
    else
      find_most_efficient2(
        positions,
        at_position + 1,
        simple_consumption,
        var_consumption,
        below,
        over,
        position_count,
        position_sum,
        position_squared_sum
      )
    end
  end

  defp group_and_sort(positions) do
    Enum.frequencies(positions)
    |> Enum.to_list()
    |> Enum.sort_by(fn {position, _} -> position end)
  end

  defp distance_from_zero(positions) do
    Enum.map(positions, fn {position, count} -> count * position end)
    |> Enum.sum()
  end

  defp sqr_distance_from_zero(positions) do
    Enum.map(positions, fn {position, count} -> count * position * position end)
    |> Enum.sum()
  end

  defp number_of_crabs(positions) do
    Enum.map(positions, fn {_, count} -> count end)
    |> Enum.sum()
  end
end
