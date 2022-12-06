use std::collections::HashSet;

use super::Result;

pub fn solve_first(input: String) -> Result {
    let res = input
        .trim_end()
        .split('\n')
        .map(|line| line.split_at(line.len() / 2))
        .map(|(first_compartment, second_compartment)| {
            (
                first_compartment.chars().collect::<HashSet<char>>(),
                second_compartment.chars().collect::<HashSet<char>>(),
            )
        })
        .flat_map(|(first_compartment, second_compartment)| {
            first_compartment
                .intersection(&second_compartment)
                .copied()
                .collect::<Vec<char>>()
        })
        .map(item_priority)
        .sum();

    Result::Number(res)
}

pub fn solve_second(input: String) -> Result {
    let res = input
        .trim_end()
        .split('\n')
        .map(|rucksack| rucksack.chars().collect::<HashSet<char>>())
        .array_chunks::<3>()
        .flat_map(|[rucksack1, rucksack2, rucksack3]| {
            rucksack1
                .iter()
                .filter(|i| rucksack2.contains(i))
                .filter(|i| rucksack3.contains(i))
                .copied()
                .collect::<Vec<char>>()
        })
        .map(item_priority)
        .sum();

    Result::Number(res)
}

fn item_priority(item: char) -> u32 {
    let item_code = item as u32;
    match item {
        'a'..='z' => item_code - ('a' as u32) + 1,
        'A'..='Z' => item_code - ('A' as u32) + 27,
        _ => panic!("Unknown item"),
    }
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "vJrwpWtwJgWrhcsFMMfFFhFp\n\
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\n\
    PmmdzqPrVvPwwTWBwg\n\
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\n\
    ttgJtRGJQctTZtZT\n\
    CrZsJsPPZsGzwwsLwLmpwMDw\n";

    #[test]
    fn solves_first() {
        assert_eq_number(157, solve_first(String::from(RAW_INPUT)));
    }

    #[test]
    fn solves_second() {
        assert_eq_number(70, solve_second(String::from(RAW_INPUT)));
    }
}
