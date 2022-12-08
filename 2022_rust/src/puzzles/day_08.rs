use super::Result;

pub fn solve_first(input: String) -> Result {
    let forest: Vec<Vec<u8>> = parse_input_into_forest(input);
    let forest_width = forest[0].len();
    let forest_height = forest.len();
    let mut visibility: Vec<Vec<bool>> = vec![vec![false; forest[0].len()]; forest.len()];
    for i in 0..forest_height {
        let mut max_height = 0;
        for j in 0..forest_width {
            let tree_height = forest[i][j];
            if max_height < tree_height {
                visibility[i][j] = true;
                max_height = tree_height;
            }
            if tree_height == b'9' {
                break;
            }
        }
    }
    for i in 0..forest_height {
        let mut max_height = 0;
        for j in (0..forest_width).rev() {
            let tree_height = forest[i][j];
            if max_height < tree_height {
                visibility[i][j] = true;
                max_height = tree_height;
            }
            if tree_height == b'9' {
                break;
            }
        }
    }
    for j in 0..forest_width {
        let mut max_height = 0;
        for i in 0..forest_height {
            let tree_height = forest[i][j];
            if max_height < tree_height {
                visibility[i][j] = true;
                max_height = tree_height;
            }
            if tree_height == b'9' {
                break;
            }
        }
    }
    for j in 0..forest_width {
        let mut max_height = 0;
        for i in (0..forest_height).rev() {
            let tree_height = forest[i][j];
            if max_height < tree_height {
                visibility[i][j] = true;
                max_height = tree_height;
            }
            if tree_height == b'9' {
                break;
            }
        }
    }

    let visible_trees = visibility
        .iter()
        .flat_map(|l| l.iter().copied())
        .filter(|v| *v)
        .count();

    Result::Number(visible_trees as u32)
}

pub fn solve_second(input: String) -> Result {
    let forest: Vec<Vec<u8>> = parse_input_into_forest(input);
    let w = forest[0].len();
    let h = forest.len();
    let mut scenic_score = 0;
    for i in 0..h {
        for j in 0..w {
            let cur_scenic_score = get_scenic_score(&forest, (h, w), (i, j));
            if scenic_score < cur_scenic_score {
                scenic_score = cur_scenic_score;
            }
        }
    }
    Result::Number(scenic_score)
}

fn parse_input_into_forest(input: String) -> Vec<Vec<u8>> {
    input
        .trim_end()
        .split('\n')
        .map(|line| line.as_bytes().to_vec())
        .collect()
}

fn get_scenic_score(forest: &[Vec<u8>], (h, w): (usize, usize), (i, j): (usize, usize)) -> u32 {
    let tree_height = forest[i][j];
    let mut score_up = 0;
    while i > score_up {
        score_up += 1;
        if forest[i - score_up][j] >= tree_height {
            break;
        }
    }
    let mut score_left = 0;
    while j > score_left {
        score_left += 1;
        if forest[i][j - score_left] >= tree_height {
            break;
        }
    }
    let mut score_down = 0;
    while i + score_down + 1 < h {
        score_down += 1;
        if forest[i + score_down][j] >= tree_height {
            break;
        }
    }
    let mut score_right = 0;
    while j + score_right + 1 < w {
        score_right += 1;
        if forest[i][j + score_right] >= tree_height {
            break;
        }
    }
    (score_up * score_left * score_down * score_right) as u32
}

#[cfg(test)]
mod tests {
    use crate::puzzles::assert_eq_number;

    use super::*;

    static RAW_INPUT: &str = "30373\n\
    25512\n\
    65332\n\
    33549\n\
    35390\n";

    #[test]
    fn solves_first() {
        assert_eq_number(21, solve_first(String::from(RAW_INPUT)));
    }

    #[test]
    fn solves_second() {
        assert_eq_number(8, solve_second(String::from(RAW_INPUT)));
    }
}
