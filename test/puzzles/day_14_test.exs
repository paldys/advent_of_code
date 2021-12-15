defmodule AdventOfCode.Puzzles.Day14Test do
  use ExUnit.Case

  @test_template 'NNCB'
  @test_rules %{
    'CH' => ?B,
    'HH' => ?N,
    'CB' => ?H,
    'NH' => ?C,
    'HB' => ?C,
    'HC' => ?B,
    'HN' => ?C,
    'NN' => ?C,
    'BH' => ?H,
    'NC' => ?B,
    'NB' => ?B,
    'BN' => ?B,
    'BB' => ?N,
    'BC' => ?B,
    'CC' => ?N,
    'CN' => ?C
  }

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day14.solve1({@test_template, @test_rules}) == 1588
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day14.solve2({@test_template, @test_rules}) == 2_188_189_693_529
  end
end
