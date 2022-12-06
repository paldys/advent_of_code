use lazy_static::lazy_static;
use regex::Regex;

use super::Result;
use crate::utils::unwrap_match_to_usize;

pub fn solve_first(input: String) -> Result {
    let res = input
        .trim_end()
        .split('\n')
        .map(parse_line)
        .filter(|[left_start, left_end, right_start, right_end]| {
            (left_start <= right_start && left_end >= right_end)
                || (left_start >= right_start && left_end <= right_end)
        })
        .count() as u32;

    Result::Number(res)
}

pub fn solve_second(input: String) -> Result {
    let res = input
        .trim_end()
        .split('\n')
        .map(parse_line)
        .filter(|[left_start, left_end, right_start, right_end]| {
            (left_start <= right_end || left_start <= right_start) && left_end >= right_start
        })
        .count() as u32;

    Result::Number(res)
}

fn parse_line(line: &str) -> [usize; 4] {
    lazy_static! {
        static ref ASSIGNMENT_PAIR_RE: Regex = Regex::new(r"^(\d+)-(\d+),(\d+)-(\d+)$").unwrap();
    }
    let captures = ASSIGNMENT_PAIR_RE
        .captures(line)
        .expect("Input line is not of expected format");
    [
        unwrap_match_to_usize(captures.get(1)),
        unwrap_match_to_usize(captures.get(2)),
        unwrap_match_to_usize(captures.get(3)),
        unwrap_match_to_usize(captures.get(4)),
    ]
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "2-4,6-8\n\
    2-3,4-5\n\
    5-7,7-9\n\
    2-8,3-7\n\
    6-6,4-6\n\
    2-6,4-8\n";

    #[test]
    fn solves_first() {
        assert_eq_number(2, solve_first(String::from(RAW_INPUT)));
    }

    #[test]
    fn solves_second() {
        assert_eq_number(4, solve_second(String::from(RAW_INPUT)));
        assert_eq_number(1, solve_second(String::from("3-4,2-6")));
    }
}
