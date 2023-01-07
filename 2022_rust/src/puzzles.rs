mod day_01;
mod day_02;
mod day_03;
mod day_04;
mod day_05;
mod day_06;
mod day_07;
mod day_08;
mod day_09;
mod day_10;
mod day_11;
mod day_12;
mod day_13;
mod day_14;
mod day_15;
mod day_16;

#[derive(Debug, PartialEq)]
pub enum Result {
    Number(u32),
    String(String),
}

fn panic_not_implemented(_: String) -> Result {
    panic!("Not implemented")
}

type Puzzle = (fn(String) -> Result, fn(String) -> Result);

pub fn get_all_puzzles() -> [Puzzle; 25] {
    [
        (day_01::solve_first, day_01::solve_second),
        (day_02::solve_first, day_02::solve_second),
        (day_03::solve_first, day_03::solve_second),
        (day_04::solve_first, day_04::solve_second),
        (day_05::solve_first, day_05::solve_second),
        (day_06::solve_first, day_06::solve_second),
        (day_07::solve_first, day_07::solve_second),
        (day_08::solve_first, day_08::solve_second),
        (day_09::solve_first, day_09::solve_second),
        (day_10::solve_first, day_10::solve_second),
        (day_11::solve_first, day_11::solve_second),
        (day_12::solve_first, day_12::solve_second),
        (day_13::solve_first, day_13::solve_second),
        (day_14::solve_first, day_14::solve_second),
        (day_15::solve_first, day_15::solve_second),
        (day_16::solve_first, day_16::solve_second),
        (panic_not_implemented, panic_not_implemented),
        (panic_not_implemented, panic_not_implemented),
        (panic_not_implemented, panic_not_implemented),
        (panic_not_implemented, panic_not_implemented),
        (panic_not_implemented, panic_not_implemented),
        (panic_not_implemented, panic_not_implemented),
        (panic_not_implemented, panic_not_implemented),
        (panic_not_implemented, panic_not_implemented),
        (panic_not_implemented, panic_not_implemented),
    ]
}

pub fn assert_eq_number(expected: u32, actual: Result) {
    assert_eq!(Result::Number(expected), actual)
}

pub fn assert_eq_string(expected: String, actual: Result) {
    assert_eq!(Result::String(expected), actual)
}
