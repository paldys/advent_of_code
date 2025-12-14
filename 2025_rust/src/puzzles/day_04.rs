use super::Result;

#[derive(PartialEq)]
enum GridValue {
    Roll,
    Empty,
}

pub fn solve_first(input: String) -> Result {
    let grid = parse_input(&input);
    let Some(row) = grid.first() else {
        return Result::Number(0);
    };
    let cols = row.len();
    let rows = grid.len();
    let mut neighbors: Vec<Vec<u32>> = vec![vec![0; cols]; rows];
    for y in 0..rows {
        for x in 0..cols {
            if grid[y][x] == GridValue::Empty {
                neighbors[y][x] = 8;
                continue;
            }
            if x < cols - 1 && grid[y][x + 1] == GridValue::Roll {
                neighbors[y][x] += 1;
                neighbors[y][x + 1] += 1;
            }
            if y < rows - 1 {
                if x > 0 && grid[y + 1][x - 1] == GridValue::Roll {
                    neighbors[y][x] += 1;
                    neighbors[y + 1][x - 1] += 1;
                }
                if grid[y + 1][x] == GridValue::Roll {
                    neighbors[y][x] += 1;
                    neighbors[y + 1][x] += 1;
                }
                if x < cols - 1 && grid[y + 1][x + 1] == GridValue::Roll {
                    neighbors[y][x] += 1;
                    neighbors[y + 1][x + 1] += 1;
                }
            }
        }
    }
    let accessible_rolls = neighbors
        .iter()
        .flat_map(|inner_vec| inner_vec.iter())
        .filter(|&&n| n < 4)
        .count();
    Result::Number(accessible_rolls as u64)
}

fn parse_input(input: &str) -> Vec<Vec<GridValue>> {
    input
        .lines()
        .map(|l| {
            l.chars()
                .map(|c| {
                    if c == '@' {
                        GridValue::Roll
                    } else {
                        GridValue::Empty
                    }
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
    ..@@.@@@@.\n\
    @@@.@.@.@@\n\
    @@@@@.@.@@\n\
    @.@@@@..@.\n\
    @@.@@@@.@@\n\
    .@@@@@@@.@\n\
    .@.@.@.@@@\n\
    @.@@@.@@@@\n\
    .@@@@@@@@.\n\
    @.@.@@@.@.\n";

    #[test]
    fn solves_first() {
        assert_eq_number(13, solve_first(String::from(RAW_INPUT)));
    }
}
