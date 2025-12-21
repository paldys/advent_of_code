use super::Result;

#[derive(PartialEq)]
enum GridValue {
    Beam,
    Splitter,
    Empty,
}

pub fn solve_first(input: String) -> Result {
    let mut grid = parse_input(&input);
    let start = grid[0].iter().position(|v| *v == GridValue::Beam).unwrap();
    let mut beams = vec![(start, 0_usize)];
    let mut splits = 0;
    while let Some((x, y)) = beams.pop() {
        if y + 1 < grid.len() {
            match grid[y + 1][x] {
                GridValue::Splitter => {
                    splits += 1;
                    if x > 0 && grid[y + 1][x - 1] != GridValue::Beam {
                        grid[y + 1][x - 1] = GridValue::Beam;
                        beams.push((x - 1, y + 1));
                    }
                    if x + 1 < grid[0].len() && grid[y + 1][x + 1] != GridValue::Beam {
                        grid[y + 1][x + 1] = GridValue::Beam;
                        beams.push((x + 1, y + 1));
                    }
                }
                GridValue::Empty => {
                    grid[y + 1][x] = GridValue::Beam;
                    beams.push((x, y + 1));
                }
                GridValue::Beam => {}
            }
        }
    }
    Result::Number(splits)
}

fn parse_input(input: &str) -> Vec<Vec<GridValue>> {
    input
        .lines()
        .map(|l| {
            l.chars()
                .map(|c| match c {
                    'S' => GridValue::Beam,
                    '^' => GridValue::Splitter,
                    '.' => GridValue::Empty,
                    _ => unreachable!("unknwon char"),
                })
                .collect()
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "\
        .......S.......\n\
        ...............\n\
        .......^.......\n\
        ...............\n\
        ......^.^......\n\
        ...............\n\
        .....^.^.^.....\n\
        ...............\n\
        ....^.^...^....\n\
        ...............\n\
        ...^.^...^.^...\n\
        ...............\n\
        ..^...^.....^..\n\
        ...............\n\
        .^.^.^.^.^...^.\n\
        ...............";

    #[test]
    fn solves_first() {
        assert_eq_number(21, solve_first(String::from(RAW_INPUT)));
    }
}
