use super::Result;

pub fn solve_first(input: String) -> Result {
    Result::Number(0)
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "L68\n\
    L30\n\
    R48\n\
    L5\n\
    R60\n\
    L55\n\
    L1\n\
    L99\n\
    R14\n\
    L82\n";

    #[test]
    fn solves_first() {
        assert_eq_number(3, solve_first(String::from(RAW_INPUT)));
    }
}
