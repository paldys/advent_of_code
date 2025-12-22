use super::Result;

pub fn solve_first(input: String) -> Result {
    let red_tiles = parse_input(&input);
    let mut max = 0;
    for left in 0..red_tiles.len() {
        for right in (left + 1)..red_tiles.len() {
            let (x1, y1) = red_tiles[left];
            let (x2, y2) = red_tiles[right];
            let area = (((x1 - x2).abs() + 1) * ((y1 - y2).abs() + 1)) as u64;
            if area > max {
                max = area;
            }
        }
    }
    Result::Number(max)
}

fn parse_input(input: &str) -> Vec<(i64, i64)> {
    input
        .lines()
        .map(|l| {
            let (x, y) = l.split_once(',').unwrap();
            (
                x.parse::<i64>().ok().unwrap(),
                y.parse::<i64>().ok().unwrap(),
            )
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "\
        7,1\n\
        11,1\n\
        11,7\n\
        9,7\n\
        9,5\n\
        2,5\n\
        2,3\n\
        7,3";

    #[test]
    fn solves_first() {
        assert_eq_number(50, solve_first(String::from(RAW_INPUT)));
    }
}
