use super::Result;

pub fn solve_first(input: String) -> Result {
    let mut at_zero = 0;
    let mut orientation = 50;
    for raw_rotation in input.lines() {
        let rotation = parse_line(raw_rotation);
        orientation = match rotation {
            Some(('L', l)) => orientation - l,
            Some(('R', r)) => orientation + r,
            _ => orientation,
        };
        orientation %= 100;
        if orientation == 0 {
            at_zero += 1;
        }
    }
    Result::Number(at_zero)
}

fn parse_line(s: &str) -> Option<(char, i32)> {
    let first = s.chars().next()?;
    if first != 'L' && first != 'R' {
        return None;
    }
    let num = s[1..].parse().ok()?;
    Some((first, num))
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
