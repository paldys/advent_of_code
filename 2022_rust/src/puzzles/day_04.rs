use lazy_static::lazy_static;
use regex::Regex;

pub fn solve_first(input: String) -> u32 {
    input
        .trim_end()
        .split('\n')
        .map(parse_line)
        .filter(|[left_start, left_end, right_start, right_end]| {
            (left_start <= right_start && left_end >= right_end)
                || (left_start >= right_start && left_end <= right_end)
        })
        .count() as u32
}

fn parse_line(line: &str) -> [u32; 4] {
    lazy_static! {
        static ref ASSIGNMENT_PAIR_RE: Regex = Regex::new(r"^(\d+)-(\d+),(\d+)-(\d+)$").unwrap();
    }
    let captures = ASSIGNMENT_PAIR_RE
        .captures(line)
        .expect("Input line is not of expected format");
    [
        unwrap_match_to_u32(captures.get(1)),
        unwrap_match_to_u32(captures.get(2)),
        unwrap_match_to_u32(captures.get(3)),
        unwrap_match_to_u32(captures.get(4)),
    ]
}

fn unwrap_match_to_u32(re_match: Option<regex::Match<'_>>) -> u32 {
    re_match
        .unwrap()
        .as_str()
        .parse()
        .expect("Expected a number here")
}

#[cfg(test)]
mod tests {
    use super::*;

    static RAW_INPUT: &str = "2-4,6-8\n\
    2-3,4-5\n\
    5-7,7-9\n\
    2-8,3-7\n\
    6-6,4-6\n\
    2-6,4-8\n";

    #[test]
    fn solves_first() {
        assert_eq!(2, solve_first(String::from(RAW_INPUT)))
    }
}
