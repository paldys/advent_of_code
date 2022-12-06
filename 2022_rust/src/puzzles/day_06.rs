use std::collections::HashSet;

use super::Result;

pub fn solve_first(input: String) -> Result {
    let datastream = input.trim_end().as_bytes();
    let datastream_length = datastream.len();

    if datastream_length < 4 {
        panic!("Input is too short");
    }

    for i in 0..(datastream_length - 3) {
        let set: HashSet<_> = datastream[i..(i + 4)].iter().collect();
        if set.len() == 4 {
            return Result::Number((i + 4) as u32);
        }
    }

    panic!("No packet marker found in input");
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT_1: &str = "mjqjpqmgbljsphdztnvjfqwrcgsmlb\n";
    static RAW_INPUT_2: &str = "bvwbjplbgvbhsrlpgdmjqwftvncz\n";
    static RAW_INPUT_3: &str = "nppdvjthqldpwncqszvftbrmjlhg\n";
    static RAW_INPUT_4: &str = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg\n";
    static RAW_INPUT_5: &str = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw\n";

    #[test]
    fn solves_first() {
        assert_eq_number(7, solve_first(String::from(RAW_INPUT_1)));
        assert_eq_number(5, solve_first(String::from(RAW_INPUT_2)));
        assert_eq_number(6, solve_first(String::from(RAW_INPUT_3)));
        assert_eq_number(10, solve_first(String::from(RAW_INPUT_4)));
        assert_eq_number(11, solve_first(String::from(RAW_INPUT_5)));
    }
}
