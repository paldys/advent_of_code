mod day_01;
mod day_02;

fn panic_not_implemented(_: String) -> u32 {
    panic!("Not implemented")
}

pub fn get_all_puzzles() -> [(fn(String) -> u32, fn(String) -> u32); 2] {
    [
        (day_01::solve_first, day_01::solve_second),
        (day_02::solve_first, panic_not_implemented),
    ]
}
