use std::collections::HashSet;

const LOWER_CASE_A: u32 = 'a' as u32;
const UPPER_CASE_A: u32 = 'A' as u32;
const ALPHABET_SIZE: u32 = 26;

pub fn solve_first(input: String) -> u32 {
    input
        .split('\n')
        .filter(|line| !line.is_empty())
        .map(|line| line.split_at(line.len() / 2))
        .map(|(first_compartment, second_compartment)| {
            (
                first_compartment.chars().collect::<HashSet<char>>(),
                second_compartment.chars().collect::<HashSet<char>>(),
            )
        })
        .map(|(first_compartment, second_compartment)| {
            first_compartment
                .intersection(&second_compartment)
                .map(|item| item_priority(*item))
                .sum::<u32>()
        })
        .sum()
}

fn item_priority(item: char) -> u32 {
    let item_priority = (item as u32) - UPPER_CASE_A + 1;
    if item_priority > ALPHABET_SIZE {
        return (item as u32) - LOWER_CASE_A + 1;
    }
    item_priority + ALPHABET_SIZE
}

#[cfg(test)]
mod tests {
    use super::*;

    static RAW_INPUT: &str = "vJrwpWtwJgWrhcsFMMfFFhFp\n\
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\n\
    PmmdzqPrVvPwwTWBwg\n\
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\n\
    ttgJtRGJQctTZtZT\n\
    CrZsJsPPZsGzwwsLwLmpwMDw";

    #[test]
    fn solves_first() {
        assert_eq!(157, solve_first(String::from(RAW_INPUT)))
    }
}
