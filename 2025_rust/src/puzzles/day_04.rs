use super::Result;

const NEIGHBORS: [(isize, isize); 8] = [
    (-1, -1),
    (-1, 0),
    (-1, 1),
    (0, -1),
    (0, 1),
    (1, -1),
    (1, 0),
    (1, 1),
];

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
                process_roll(y, x, &mut grid, &mut neighbors, &mut stack);
            }
        }
        Result::Number(rolls)
    }
}

fn process_roll(
    y: usize,
    x: usize,
    grid: &mut [Vec<GridValue>],
    neighbors: &mut [Vec<u32>],
    stack: &mut Vec<(usize, usize)>,
) {
    grid[y][x] = GridValue::Empty;

    let rows = grid.len();
    let cols = grid[0].len();

    for (ny, nx) in neighbors_of(y, x, rows, cols) {
        if grid[ny][nx] == GridValue::Roll {
            neighbors[ny][nx] -= 1;
            if neighbors[ny][nx] < 4 {
                stack.push((ny, nx));
            }
        }
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
            for (ny, nx) in neighbors_of(y, x, rows, cols) {
                if grid[ny][nx] == GridValue::Roll {
                    neighbors[y][x] += 1;
                }
            }
        }
    }
    neighbors
}

fn neighbors_of(
    y: usize,
    x: usize,
    rows: usize,
    cols: usize,
) -> impl Iterator<Item = (usize, usize)> {
    NEIGHBORS.into_iter().filter_map(move |(dy, dx)| {
        let ny = y as isize + dy;
        let nx = x as isize + dx;
        if ny >= 0 && nx >= 0 && ny < rows as isize && nx < cols as isize {
            Some((ny as usize, nx as usize))
        } else {
            None
        }
    })
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
