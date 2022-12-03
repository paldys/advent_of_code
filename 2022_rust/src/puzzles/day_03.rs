use std::collections::HashSet;

pub fn solve_first(input: String) -> u32 {
    input
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
                .map(|i| *i)
                .collect::<Vec<char>>()
        })
        .map(item_priority)
        .sum()
}

pub fn solve_second(input: String) -> u32 {
    input
        .trim_end()
        .split('\n')
        .map(|rucksack| rucksack.chars().collect::<HashSet<char>>())
        .array_chunks::<3>()
        .flat_map(|[rucksack1, rucksack2, rucksack3]| {
            rucksack1
                .iter()
                .filter(|i| rucksack2.contains(i))
                .filter(|i| rucksack3.contains(i))
                .map(|i| *i)
                .collect::<Vec<char>>()
        })
        .map(item_priority)
        .sum()
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
    use super::*;

    static RAW_INPUT: &str = "vJrwpWtwJgWrhcsFMMfFFhFp\n\
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\n\
    PmmdzqPrVvPwwTWBwg\n\
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\n\
    ttgJtRGJQctTZtZT\n\
    CrZsJsPPZsGzwwsLwLmpwMDw\n";

    #[test]
    fn solves_first() {
        assert_eq!(157, solve_first(String::from(RAW_INPUT)))
    }

    #[test]
    fn solves_second() {
        assert_eq!(70, solve_second(String::from(RAW_INPUT)))
    }
}
