use phf::phf_map;

static SCORE_SHEET_1: phf::Map<char, phf::Map<char, u32>> = phf_map! {
    'A' => phf_map! {
        'X' => 1 + 3,
        'Y' => 2 + 6,
        'Z' => 3 + 0,
    },
    'B' => phf_map! {
        'X' => 1 + 0,
        'Y' => 2 + 3,
        'Z' => 3 + 6,
    },
    'C' => phf_map! {
        'X' => 1 + 6,
        'Y' => 2 + 0,
        'Z' => 3 + 3,
    },
};

static SCORE_SHEET_2: phf::Map<char, phf::Map<char, u32>> = phf_map! {
    'A' => phf_map! {
        'X' => 3 + 0,
        'Y' => 1 + 3,
        'Z' => 2 + 6,
    },
    'B' => phf_map! {
        'X' => 1 + 0,
        'Y' => 2 + 3,
        'Z' => 3 + 6,
    },
    'C' => phf_map! {
        'X' => 2 + 0,
        'Y' => 3 + 3,
        'Z' => 1 + 6,
    },
};

pub fn solve_first(input: String) -> u32 {
    solve(input, &SCORE_SHEET_1)
}

pub fn solve_second(input: String) -> u32 {
    solve(input, &SCORE_SHEET_2)
}

fn solve(input: String, score_sheet: &phf::Map<char, phf::Map<char, u32>>) -> u32 {
    let mut score = 0;
    for line in input.trim_end().split('\n') {
        let mut line = line.chars();
        let opponent = line
            .next()
            .expect("The expected line length is 3 characters");
        line.next(); // skip space
        let player: char = line
            .next()
            .expect("The expected line length is 3 characters");
        match score_sheet.get(&opponent).map(|m| m.get(&player)).flatten() {
            Some(current_score) => score += current_score,
            None => panic!("Unknown character"),
        }
    }
    score
}

#[cfg(test)]
mod tests {
    use super::*;

    static RAW_INPUT: &str = "A Y\n\
    B X\n\
    C Z\n";

    #[test]
    fn solves_first() {
        assert_eq!(15, solve_first(String::from(RAW_INPUT)))
    }

    #[test]
    fn solves_second() {
        assert_eq!(12, solve_second(String::from(RAW_INPUT)))
    }
}
