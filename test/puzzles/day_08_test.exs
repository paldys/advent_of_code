defmodule AdventOfCode.Puzzles.Day08Test do
  use ExUnit.Case

  @test_input """
  be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
  edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
  fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
  fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
  aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
  fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
  dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
  bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
  egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
  gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
  """

  @test_signals [
    {['be', 'cfbegad', 'cbdgef', 'fgaecd', 'cgeb', 'fdcge', 'agebfd', 'fecdb', 'fabcd', 'edb'],
     ['fdgacbe', 'cefdb', 'cefbgd', 'gcbe']},
    {['edbfga', 'begcd', 'cbg', 'gc', 'gcadebf', 'fbgde', 'acbgfd', 'abcde', 'gfcbed', 'gfec'],
     ['fcgedb', 'cgb', 'dgebacf', 'gc']},
    {['fgaebd', 'cg', 'bdaec', 'gdafb', 'agbcfd', 'gdcbef', 'bgcad', 'gfac', 'gcb', 'cdgabef'],
     ['cg', 'cg', 'fdcagb', 'cbg']},
    {['fbegcd', 'cbd', 'adcefb', 'dageb', 'afcb', 'bc', 'aefdc', 'ecdab', 'fgdeca', 'fcdbega'],
     ['efabcd', 'cedba', 'gadfec', 'cb']},
    {['aecbfdg', 'fbg', 'gf', 'bafeg', 'dbefa', 'fcge', 'gcbea', 'fcaegb', 'dgceab', 'fcbdga'],
     ['gecf', 'egdcabf', 'bgf', 'bfgea']},
    {['fgeab', 'ca', 'afcebg', 'bdacfeg', 'cfaedg', 'gcfdb', 'baec', 'bfadeg', 'bafgc', 'acf'],
     ['gebdcfa', 'ecba', 'ca', 'fadegcb']},
    {['dbcfg', 'fgd', 'bdegcaf', 'fgec', 'aegbdf', 'ecdfab', 'fbedc', 'dacgb', 'gdcebf', 'gf'],
     ['cefg', 'dcbef', 'fcge', 'gbcadfe']},
    {['bdfegc', 'cbegaf', 'gecbf', 'dfcage', 'bdacg', 'ed', 'bedf', 'ced', 'adcbefg', 'gebcd'],
     ['ed', 'bcgafe', 'cdgba', 'cbgef']},
    {['egadfb', 'cdbfeg', 'cegd', 'fecab', 'cgb', 'gbdefca', 'cg', 'fgcdab', 'egfdb', 'bfceg'],
     ['gbdfcae', 'bgc', 'cg', 'cgb']},
    {['gcafb', 'gcf', 'dcaebfg', 'ecagb', 'gf', 'abcdeg', 'gaef', 'cafbge', 'fdbac', 'fegbdc'],
     ['fgae', 'cfgab', 'fg', 'bagce']}
  ]

  test "parse input" do
    assert AdventOfCode.Puzzles.Day08.parse(@test_input) == @test_signals
  end

  test "solve 1st puzzle" do
    assert AdventOfCode.Puzzles.Day08.solve1(@test_signals) == 26
  end

  test "solve 2nd puzzle" do
    assert AdventOfCode.Puzzles.Day08.solve2(@test_signals) == 61229
  end
end
