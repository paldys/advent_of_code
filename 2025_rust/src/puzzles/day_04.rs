use super::Result;

#[derive(PartialEq)]
enum GridValue {
    Roll,
    Empty,
}

pub fn solve_first(input: String) -> Result {
    solve(input, true)
}

pub fn solve_second(input: String) -> Result {
    solve(input, false)
}

fn solve(input: String, only_first: bool) -> Result {
    let mut grid = parse_input(&input);
    let Some(row) = grid.first() else {
        return Result::Number(0);
    };
    let cols = row.len();
    let rows = grid.len();
    let mut neighbors = calculate_neighbors(rows, cols, &grid);
    let mut stack: Vec<(usize, usize)> = Vec::new();
    for (y, row) in neighbors.iter().enumerate() {
        for (x, count) in row.iter().enumerate() {
            if *count < 4 {
                stack.push((y, x));
            }
        }
    }
    if only_first {
        Result::Number(stack.len() as u64)
    } else {
        let mut rolls = 0;
        while let Some((y, x)) = stack.pop() {
            if grid[y][x] == GridValue::Roll {
                rolls += 1;
                grid[y][x] = GridValue::Empty;
                if y > 0 {
                    if x > 0 && grid[y - 1][x - 1] == GridValue::Roll {
                        neighbors[y - 1][x - 1] -= 1;
                        if neighbors[y - 1][x - 1] < 4 {
                            stack.push((y - 1, x - 1));
                        }
                    }
                    if grid[y - 1][x] == GridValue::Roll {
                        neighbors[y - 1][x] -= 1;
                        if neighbors[y - 1][x] < 4 {
                            stack.push((y - 1, x));
                        }
                    }
                    if x < cols - 1 && grid[y - 1][x + 1] == GridValue::Roll {
                        neighbors[y - 1][x + 1] -= 1;
                        if neighbors[y - 1][x + 1] < 4 {
                            stack.push((y - 1, x + 1));
                        }
                    }
                }
                if x > 0 && grid[y][x - 1] == GridValue::Roll {
                    neighbors[y][x - 1] -= 1;
                    if neighbors[y][x - 1] < 4 {
                        stack.push((y, x - 1));
                    }
                }
                if x < cols - 1 && grid[y][x + 1] == GridValue::Roll {
                    neighbors[y][x + 1] -= 1;
                    if neighbors[y][x + 1] < 4 {
                        stack.push((y, x + 1));
                    }
                }
                if y < rows - 1 {
                    if x > 0 && grid[y + 1][x - 1] == GridValue::Roll {
                        neighbors[y + 1][x - 1] -= 1;
                        if neighbors[y + 1][x - 1] < 4 {
                            stack.push((y + 1, x - 1));
                        }
                    }
                    if grid[y + 1][x] == GridValue::Roll {
                        neighbors[y + 1][x] -= 1;
                        if neighbors[y + 1][x] < 4 {
                            stack.push((y + 1, x));
                        }
                    }
                    if x < cols - 1 && grid[y + 1][x + 1] == GridValue::Roll {
                        neighbors[y + 1][x + 1] -= 1;
                        if neighbors[y + 1][x + 1] < 4 {
                            stack.push((y + 1, x + 1));
                        }
                    }
                }
            }
        }
        Result::Number(rolls)
    }
}

fn calculate_neighbors(rows: usize, cols: usize, grid: &[Vec<GridValue>]) -> Vec<Vec<u32>> {
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
    neighbors
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

    #[test]
    fn solves_second() {
        assert_eq_number(43, solve_second(String::from(RAW_INPUT)));
    }
}
