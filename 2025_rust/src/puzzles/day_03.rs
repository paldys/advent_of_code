use super::Result;

const MIN_DIGIT: u8 = b'0';
const MAX_DIGIT: u8 = b'9';

pub fn solve_first(input: String) -> Result {
    solve(input, 2)
}

pub fn solve_second(input: String) -> Result {
    solve(input, 12)
}

fn solve(input: String, size: usize) -> Result {
    let joltage = input
        .lines()
        .map(|line| calculate_joltage(line, size))
        .sum();
    Result::Number(joltage)
}

fn calculate_joltage(line: &str, size: usize) -> u64 {
    let bytes = line.as_bytes();
    let mut joltage = 0_u64;
    let mut i;
    let mut max;
    let mut next_start = 0;
    for d in (0..=size - 1).rev() {
        i = next_start;
        max = MIN_DIGIT;
        while i < bytes.len() - d && max != MAX_DIGIT {
            if bytes[i] > max {
                max = bytes[i];
                next_start = i + 1;
            }
            i += 1;
        }
        joltage = joltage * 10 + u64::from(max - MIN_DIGIT);
    }

    joltage
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "\
    987654321111111\n\
    811111111111119\n\
    234234234234278\n\
    818181911112111\n";

    #[test]
    fn solves_first() {
        assert_eq_number(357, solve_first(String::from(RAW_INPUT)));
    }

    #[test]
    fn solves_second() {
        assert_eq_number(3121910778619, solve_second(String::from(RAW_INPUT)));
    }
}
