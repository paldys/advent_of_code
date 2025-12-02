use super::Result;

pub fn solve_first(input: String) -> Result {
    let mut sum = 0;
    for raw_range in input.trim().split(',') {
        let range = parse_range(raw_range);
        if let Some((len, lower, upper)) = range {
            let mut s = if len % 2 == 1 { len / 2 + 1 } else { len / 2 };
            let mut d = 10_u64.pow(s) + 1;
            let mut half = if len % 2 == 1 { starter(s) } else { lower / d };
            let mut full = half * d;
            while full <= upper {
                if full >= lower {
                    sum += full;
                }
                half += 1;
                full += d;
                if half == d - 1 {
                    s += 1;
                    d = 10_u64.pow(s) + 1;
                    half = starter(2);
                    full = starter(s) * d;
                }
            }
        }
    }
    Result::Number(sum)
}

fn starter(scale: u32) -> u64 {
    10_u64.pow(scale - 1)
}

fn parse_range(s: &str) -> Option<(u32, u64, u64)> {
    let mut range: Vec<_> = s.split('-').collect();
    let upper = range.pop();
    let lower = range.pop();
    match (lower, upper) {
        (Some(l), Some(u)) => Some((
            l.len().try_into().unwrap(),
            l.parse().ok()?,
            u.parse().ok()?,
        )),
        _ => None,
    }
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "\
    11-22,95-115,998-1012,1188511880-1188511890,\
    222220-222224,1698522-1698528,446443-446449,\
    38593856-38593862,565653-565659,\
    824824821-824824827,2121212118-2121212124";

    #[test]
    fn solves_first() {
        assert_eq_number(1227775554, solve_first(String::from(RAW_INPUT)));
    }
}
