pub fn solve_first(input: String) -> u32 {
    let mut most_calories = 0;
    let mut current_calories = 0;
    for line in input.split('\n') {
        let trimmed_line = line.trim();
        if trimmed_line.is_empty() {
            most_calories = most_calories.max(current_calories);
            current_calories = 0;
        } else {
            let calory: u32 = trimmed_line.parse().expect("Not a number");
            current_calories += calory;
        }
    }
    most_calories.max(current_calories)
}

#[cfg(test)]
mod tests {
    use super::*;

    static RAW_INPUT: &str = "1000\n\
    2000\n\
    3000\n\
    \n\
    4000\n\
    \n\
    5000\n\
    6000\n\
    \n\
    7000\n\
    8000\n\
    9000\n\
    \n\
    10000";

    #[test]
    fn solves_first() {
        assert_eq!(24000, solve_first(String::from(RAW_INPUT)))
    }
}
