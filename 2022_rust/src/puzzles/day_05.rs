use lazy_static::lazy_static;
use regex::Regex;

use super::Result;
use crate::utils::unwrap_match_to_usize;

const SPACE_CHAR: u8 = ' ' as u8;
const STACK_STEPPER: usize = 4;

pub fn solve_first(input: String) -> Result {
    let (mut stacks, operations) = parse_input(input);

    for (count, from, to) in operations {
        for _ in 1..=count {
            let from_stack = &mut stacks[from];
            if let Some(item) = from_stack.pop() {
                let to_stack = &mut stacks[to];
                to_stack.push(item);
            }
        }
    }

    let mut top_of_stacks = String::new();
    for stack in &stacks {
        if let Some(top_of_stack) = stack.last() {
            top_of_stacks.push(*top_of_stack as char);
        }
    }

    Result::String(top_of_stacks)
}

fn parse_input(input: String) -> (Vec<Vec<u8>>, Vec<(usize, usize, usize)>) {
    let mut stacks: Vec<Vec<u8>> = Vec::new();
    let mut operations: Vec<(usize, usize, usize)> = Vec::new();
    let mut parse_stacks = true;
    for line in input.trim_end().split('\n') {
        if parse_stacks {
            let line = line.as_bytes();
            if '1' as u8 == line[1] {
                parse_stacks = false;
                continue;
            }
            let mut iter = line.into_iter();
            iter.next(); // skip first char
            for (index, &item) in iter.enumerate().step_by(STACK_STEPPER) {
                let stack_index = index / STACK_STEPPER;
                if stacks.len() <= stack_index {
                    stacks.push(Vec::new());
                }
                if SPACE_CHAR != item {
                    let stack = &mut stacks[stack_index];
                    stack.push(item);
                }
            }
        } else if !line.is_empty() {
            operations.push(parse_operation(line));
        }
    }

    for stack in &mut stacks {
        stack.reverse();
    }

    (stacks, operations)
}

fn parse_operation(line: &str) -> (usize, usize, usize) {
    lazy_static! {
        static ref OPERATION_RE: Regex = Regex::new(r"^move (\d+) from (\d+) to (\d+)$").unwrap();
    }
    let captures = OPERATION_RE
        .captures(line)
        .expect("Input line is not of expected format");
    (
        unwrap_match_to_usize(captures.get(1)),
        unwrap_match_to_usize(captures.get(2)) - 1,
        unwrap_match_to_usize(captures.get(3)) - 1,
    )
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_string;

    use super::*;

    static RAW_INPUT: &str = "    [D]    \n\
    [N] [C]    \n\
    [Z] [M] [P]\n 1   2   3 \n\
    \n\
    move 1 from 2 to 1\n\
    move 3 from 1 to 3\n\
    move 2 from 2 to 1\n\
    move 1 from 1 to 2\n";

    #[test]
    fn parses_input() {
        let (stacks, operations) = parse_input(String::from(RAW_INPUT));
        assert_eq!(
            vec![
                vec!['Z' as u8, 'N' as u8],
                vec!['M' as u8, 'C' as u8, 'D' as u8],
                vec!['P' as u8]
            ],
            stacks
        );
        assert_eq!(vec![(1, 1, 0), (3, 0, 2), (2, 1, 0), (1, 0, 1)], operations);
    }

    #[test]
    fn solves_first() {
        assert_eq_string(String::from("CMZ"), solve_first(String::from(RAW_INPUT)));
    }
}
