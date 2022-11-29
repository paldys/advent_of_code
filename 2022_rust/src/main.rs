use clap::Parser;

#[derive(Parser)]
struct Args {
    /// The day of the puzzle
    day: u8,
    /// The number of the puzzle
    puzzle: u8,
}

fn main() {
    let args = Args::parse();

    println!("Solve Day {} Puzzle #{}", args.day, args.puzzle);
}
