use std::collections::BinaryHeap;

pub fn solve_first(input: String) -> u32 {
    solve(input, 1)
}

pub fn solve_second(input: String) -> u32 {
    solve(input, 3)
}

fn solve(input: String, top_n: u32) -> u32 {
    let mut calory_heap: BinaryHeap<u32> = BinaryHeap::new();

    let mut current_calories = 0;
    for line in input.split('\n') {
        let trimmed_line = line.trim();
        if trimmed_line.is_empty() {
            calory_heap.push(current_calories);
            current_calories = 0;
        } else {
            let calory: u32 = trimmed_line.parse().expect("Not a number");
            current_calories += calory;
        }
    }
    calory_heap.push(current_calories);

    let mut most_calories_sum = 0;
    for _ in 1..=top_n {
        most_calories_sum += calory_heap.pop().unwrap_or(0);
    }
    most_calories_sum
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

    #[test]
    fn solves_second() {
        assert_eq!(45000, solve_second(String::from(RAW_INPUT)))
    }
}
