use super::Result;

type MapWithStartAndEnd = (Vec<Vec<u8>>, (usize, usize), (usize, usize));

pub fn solve_first(input: String) -> Result {
    let (height_map, (start_x, start_y), (end_x, end_y)) = parse_input(input);
    let h = height_map.len();
    let w = height_map[0].len();
    let mut shortest_path: Vec<Vec<i32>> = vec![vec![-1; w]; h];
    shortest_path[start_x][start_y] = 0;
    let mut to_check = vec![(start_x, start_y)];
    while let Some((x, y)) = to_check.pop() {
        if x + 1 < h {
            check_and_go(
                &mut to_check,
                &mut shortest_path,
                &height_map,
                (x, y),
                (x + 1, y),
            );
        }
        if x > 0 {
            check_and_go(
                &mut to_check,
                &mut shortest_path,
                &height_map,
                (x, y),
                (x - 1, y),
            );
        }
        if y + 1 < w {
            check_and_go(
                &mut to_check,
                &mut shortest_path,
                &height_map,
                (x, y),
                (x, y + 1),
            );
        }
        if y > 0 {
            check_and_go(
                &mut to_check,
                &mut shortest_path,
                &height_map,
                (x, y),
                (x, y - 1),
            );
        }
    }

    Result::Number(shortest_path[end_x][end_y] as u32)
}

fn check_and_go(
    to_check: &mut Vec<(usize, usize)>,
    shortest_path: &mut [Vec<i32>],
    height_map: &[Vec<u8>],
    (from_x, from_y): (usize, usize),
    (to_x, to_y): (usize, usize),
) {
    if (shortest_path[to_x][to_y] == -1
        || shortest_path[from_x][from_y] + 1 < shortest_path[to_x][to_y])
        && height_map[from_x][from_y] + 1 >= height_map[to_x][to_y]
    {
        shortest_path[to_x][to_y] = shortest_path[from_x][from_y] + 1;
        to_check.push((to_x, to_y));
    }
}

fn parse_input(input: String) -> MapWithStartAndEnd {
    let mut start: Option<(usize, usize)> = None;
    let mut end: Option<(usize, usize)> = None;
    let height_map = input
        .trim_end()
        .split('\n')
        .enumerate()
        .map(|(i, line)| {
            line.as_bytes()
                .iter()
                .enumerate()
                .map(|(j, &e)| match e {
                    b'S' => {
                        start = Some((i, j));
                        b'a'
                    }
                    b'E' => {
                        end = Some((i, j));
                        b'z'
                    }
                    e => e,
                })
                .collect()
        })
        .collect();
    (height_map, start.unwrap(), end.unwrap())
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "Sabqponm\n\
    abcryxxl\n\
    accszExk\n\
    acctuvwj\n\
    abdefghi\n";

    #[test]
    fn solves_first() {
        assert_eq_number(31, solve_first(String::from(RAW_INPUT)));
    }
}
