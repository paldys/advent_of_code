use clap::Parser;
use std::fs;

pub mod puzzles;

#[derive(Parser)]
struct Args {
    /// The day of the puzzle
    day: u8,
    /// The number of the puzzle
    puzzle: u8,
}

fn main() {
    let day_01_input =
        fs::read_to_string("resources/day_01_input.txt").expect("Could not read input");

    println!("Answer: {}", puzzles::day_01::solve_first(day_01_input))
}
