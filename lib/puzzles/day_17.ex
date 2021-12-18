defmodule AdventOfCode.Puzzles.Day17 do
  @moduledoc """
  You finally decode the Elves' message. HI, the message says. You continue
  searching for the sleigh keys.

  Ahead of you is what appears to be a large ocean trench. Could the keys have
  fallen into it? You'd better send a probe to investigate.

  The probe launcher on your submarine can fire the probe with any integer
  velocity in the x (forward) and y (upward, or downward if negative)
  directions. For example, an initial x,y velocity like 0,10 would fire
  the probe straight up, while an initial velocity like 10,-1 would fire
  the probe forward at a slight downward angle.

  The probe's x,y position starts at 0,0. Then, it will follow some trajectory
  by moving in steps. On each step, these changes occur in the following order:

      - The probe's x position increases by its x velocity.
      - The probe's y position increases by its y velocity.
      - Due to drag, the probe's x velocity changes by 1 toward the value 0;
      that is, it decreases by 1 if it is greater than 0, increases by 1 if
      it is less than 0, or does not change if it is already 0.
      - Due to gravity, the probe's y velocity decreases by 1.

  For the probe to successfully make it into the trench, the probe must be
  on some trajectory that causes it to be within a target area after any step.
  The submarine computer has already calculated this target area (your puzzle
  input). For example:

  target area: x=20..30, y=-10..-5

  This target area means that you need to find initial x,y velocity values such
  that after any step, the probe's x position is at least 20 and at most 30, and
  the probe's y position is at least -10 and at most -5.

  Given this target area, one initial velocity that causes the probe to be
  within the target area after any step is 7,2:

  .............#....#............
  .......#..............#........
  ...............................
  S........................#.....
  ...............................
  ...............................
  ...........................#...
  ...............................
  ....................TTTTTTTTTTT
  ....................TTTTTTTTTTT
  ....................TTTTTTTT#TT
  ....................TTTTTTTTTTT
  ....................TTTTTTTTTTT
  ....................TTTTTTTTTTT

  In this diagram, S is the probe's initial position, 0,0. The x coordinate
  increases to the right, and the y coordinate increases upward. In the bottom
  right, positions that are within the target area are shown as T. After each
  step (until the target area is reached), the position of the probe is marked
  with #. (The bottom-right # is both a position the probe reaches and
  a position in the target area.)

  Another initial velocity that causes the probe to be within the target area
  after any step is 6,3:

  ...............#..#............
  ...........#........#..........
  ...............................
  ......#..............#.........
  ...............................
  ...............................
  S....................#.........
  ...............................
  ...............................
  ...............................
  .....................#.........
  ....................TTTTTTTTTTT
  ....................TTTTTTTTTTT
  ....................TTTTTTTTTTT
  ....................TTTTTTTTTTT
  ....................T#TTTTTTTTT
  ....................TTTTTTTTTTT

  Another one is 9,0:

  S........#.....................
  .................#.............
  ...............................
  ........................#......
  ...............................
  ....................TTTTTTTTTTT
  ....................TTTTTTTTTT#
  ....................TTTTTTTTTTT
  ....................TTTTTTTTTTT
  ....................TTTTTTTTTTT
  ....................TTTTTTTTTTT

  One initial velocity that doesn't cause the probe to be within the target
  area after any step is 17,-4:

  S..............................................................
  ...............................................................
  ...............................................................
  ...............................................................
  .................#.............................................
  ....................TTTTTTTTTTT................................
  ....................TTTTTTTTTTT................................
  ....................TTTTTTTTTTT................................
  ....................TTTTTTTTTTT................................
  ....................TTTTTTTTTTT..#.............................
  ....................TTTTTTTTTTT................................
  ...............................................................
  ...............................................................
  ...............................................................
  ...............................................................
  ................................................#..............
  ...............................................................
  ...............................................................
  ...............................................................
  ...............................................................
  ...............................................................
  ...............................................................
  ..............................................................#

  The probe appears to pass through the target area, but is never within it
  after any step. Instead, it continues down and to the right - only the first
  few steps are shown.

  If you're going to fire a highly scientific probe out of a super cool probe
  launcher, you might as well do it with style. How high can you make the probe
  go while still reaching the target area?

  In the above example, using an initial velocity of 6,9 is the best you can do,
  causing the probe to reach a maximum y position of 45. (Any higher initial
  y velocity causes the probe to overshoot the target area entirely.)

  Find the initial velocity that causes the probe to reach the highest
  y position and still eventually be within the target area after any step.
  What is the highest y position it reaches on this trajectory?

  --- Part Two ---

  Maybe a fancy trick shot isn't the best idea; after all, you only have one
  probe, so you had better not miss.

  To get the best idea of what your options are for launching the probe, you
  need to find every initial velocity that causes the probe to eventually
  be within the target area after any step.

  In the above example, there are 112 different initial velocity values that
  meet these criteria:

  23,-10  25,-9   27,-5   29,-6   22,-6   21,-7   9,0     27,-7   24,-5
  25,-7   26,-6   25,-5   6,8     11,-2   20,-5   29,-10  6,3     28,-7
  8,0     30,-6   29,-8   20,-10  6,7     6,4     6,1     14,-4   21,-6
  26,-10  7,-1    7,7     8,-1    21,-9   6,2     20,-7   30,-10  14,-3
  20,-8   13,-2   7,3     28,-8   29,-9   15,-3   22,-5   26,-8   25,-8
  25,-6   15,-4   9,-2    15,-2   12,-2   28,-9   12,-3   24,-6   23,-7
  25,-10  7,8     11,-3   26,-7   7,1     23,-9   6,0     22,-10  27,-6
  8,1     22,-8   13,-4   7,6     28,-6   11,-4   12,-4   26,-9   7,4
  24,-10  23,-8   30,-8   7,0     9,-1    10,-1   26,-5   22,-9   6,5
  7,5     23,-6   28,-10  10,-2   11,-1   20,-9   14,-2   29,-7   13,-3
  23,-5   24,-8   27,-9   30,-7   28,-5   21,-10  7,9     6,6     21,-5
  27,-10  7,2     30,-9   21,-8   22,-7   24,-9   20,-6   6,9     29,-5
  8,-2    27,-8   30,-5   24,-7

  How many distinct initial velocity values cause the probe to be within
  the target area after any step?
  """

  def parse(input) do
    [min_x, max_x, min_y, max_y] =
      Regex.run(
        ~r/^target area\: x=(-?[[:digit:]]+)\.\.(-?[[:digit:]]+), y=(-?[[:digit:]]+)\.\.(-?[[:digit:]]+)$/,
        String.trim(input),
        capture: :all_but_first
      )
      |> Enum.map(&String.to_integer/1)

    {{min_x, max_x}, {min_y, max_y}}
  end

  def solve1({_, y_range}) do
    check_y_range_negative(y_range)
    check_range_sorted(y_range)

    max_y_velocity = max_y_velocity(y_range)
    div(max_y_velocity * max_y_velocity + max_y_velocity, 2)
  end

  def solve2({x_range, y_range}) do
    check_x_range_positive(x_range)
    check_y_range_negative(y_range)
    check_range_sorted(x_range)
    check_range_sorted(y_range)

    min_x_velocity = min_x_velocity(x_range)
    max_x_velocity = max_x_velocity(x_range)

    min_y_velocity = min_y_velocity(y_range)
    max_y_velocity = max_y_velocity(y_range)

    steps_for_x_velocity =
      Enum.reduce(min_x_velocity..max_x_velocity, %{}, fn x_velocity, steps_for_x_velocity ->
        x_in_range_steps = find_x_in_range_steps(x_range, x_velocity, x_velocity)

        Enum.reduce(x_in_range_steps, steps_for_x_velocity, fn step, steps_for_x_velocity ->
          case step do
            {:lasting, step} ->
              Map.update(
                steps_for_x_velocity,
                :lasting,
                [{step, x_velocity}],
                &[{step, x_velocity} | &1]
              )

            _ ->
              Map.update(steps_for_x_velocity, step, [x_velocity], &[x_velocity | &1])
          end
        end)
      end)

    in_range_velocities =
      Enum.reduce(min_y_velocity..max_y_velocity, MapSet.new(), fn y_velocity,
                                                                   in_range_velocities ->
        y_in_range_steps =
          if y_velocity > 0 do
            find_y_in_range_steps(y_range, -y_velocity - 1, -y_velocity - 1, y_velocity * 2 + 2)
          else
            find_y_in_range_steps(y_range, y_velocity, y_velocity)
          end

        Enum.reduce(y_in_range_steps, in_range_velocities, fn step, in_range_velocities ->
          updated_in_range_velocities =
            Enum.reduce(
              Map.get(steps_for_x_velocity, step, []),
              in_range_velocities,
              fn x_velocity, in_range_velocities ->
                MapSet.put(in_range_velocities, {x_velocity, y_velocity})
              end
            )

          Enum.filter(Map.get(steps_for_x_velocity, :lasting, []), fn {lasting_step, _} ->
            lasting_step <= step
          end)
          |> Enum.reduce(updated_in_range_velocities, fn {_, x_velocity}, in_range_velocities ->
            MapSet.put(in_range_velocities, {x_velocity, y_velocity})
          end)
        end)
      end)

    MapSet.size(in_range_velocities)
  end

  defp check_x_range_positive({x1, x2}) do
    if x1 < 0 or x2 < 0 do
      raise ArgumentError,
        message: "x range should be positive only... so we keep the computations easier..."
    end
  end

  defp check_y_range_negative({y1, y2}) do
    if y1 > 0 or y2 > 0 do
      raise ArgumentError,
        message: "y range should be negative only... so we keep the computations easier..."
    end
  end

  defp check_range_sorted({r1, r2}) do
    if r1 > r2 do
      raise ArgumentError, message: "Range should start from lower number... #{r1} > #{r2}"
    end
  end

  defp max_y_velocity({y1, _}), do: abs(y1) - 1
  defp min_y_velocity({y1, _}), do: y1

  defp min_x_velocity({x1, _}), do: Kernel.ceil((:math.sqrt(1 + 8 * x1) - 1) / 2)
  defp max_x_velocity({_, x2}), do: x2

  defp find_y_in_range_steps(
         {min_y, max_y},
         at_y,
         last_y_velocity,
         step \\ 1,
         in_range_steps \\ []
       ) do
    updated_in_range_steps =
      if min_y <= at_y and max_y >= at_y, do: [step | in_range_steps], else: in_range_steps

    updated_y_velocity = last_y_velocity - 1
    updated_at_y = at_y + updated_y_velocity

    if min_y > updated_at_y do
      updated_in_range_steps
    else
      find_y_in_range_steps(
        {min_y, max_y},
        updated_at_y,
        updated_y_velocity,
        step + 1,
        updated_in_range_steps
      )
    end
  end

  defp find_x_in_range_steps(
         {min_x, max_x},
         at_x,
         last_x_velocity,
         step \\ 1,
         in_range_steps \\ []
       ) do
    updated_in_range_steps =
      if min_x <= at_x and max_x >= at_x, do: [step | in_range_steps], else: in_range_steps

    updated_x_velocity = last_x_velocity - 1
    updated_at_x = at_x + updated_x_velocity

    cond do
      max_x < updated_at_x ->
        updated_in_range_steps

      updated_x_velocity == 0 ->
        [{:lasting, step} | in_range_steps]

      true ->
        find_x_in_range_steps(
          {min_x, max_x},
          updated_at_x,
          updated_x_velocity,
          step + 1,
          updated_in_range_steps
        )
    end
  end
end
