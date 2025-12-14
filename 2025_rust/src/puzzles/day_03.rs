use super::Result;

const MIN_DIGIT: u8 = b'0';
const MAX_DIGIT: u8 = b'9';

pub fn solve_first(input: String) -> Result {
    let joltage = input.trim().lines().map(calculate_joltage).sum();
    Result::Number(joltage)
}

fn calculate_joltage(line: &str) -> u64 {
    let bytes = line.as_bytes();
    let mut i = 0;
    let mut start_i = 0;
    let mut start_value = MIN_DIGIT;
    while i < bytes.len() - 1 && start_value != MAX_DIGIT {
        if bytes[i] > start_value {
            start_value = bytes[i];
            start_i = i;
        }
        i += 1;
    }

    i = bytes.len() - 1;
    let mut end_value = MIN_DIGIT;
    while i > start_i && end_value != MAX_DIGIT {
        if bytes[i] > end_value {
            end_value = bytes[i];
        }
        i -= 1;
    }
    10 * u64::from(start_value - MIN_DIGIT) + u64::from(end_value - MIN_DIGIT)
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
}
