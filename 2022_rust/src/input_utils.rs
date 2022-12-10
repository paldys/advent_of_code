use std::fs;

pub fn get_input(day: usize) -> String {
    let file_name = format!("day_{day:0>2}_input.txt");
    read_from_resources(file_name)
}

pub fn get_test_input(day: usize) -> String {
    let file_name = format!("day_{day:0>2}_input_test.txt");
    read_from_resources(file_name)
}

fn read_from_resources(file_name: String) -> String {
    let full_path = format!("resources/{file_name}");
    fs::read_to_string(full_path).expect("Could not open input file")
}
