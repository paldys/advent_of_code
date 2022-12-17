pub fn unwrap_match_to_usize(re_match: Option<regex::Match<'_>>) -> usize {
    re_match
        .unwrap()
        .as_str()
        .parse()
        .expect("Expected a number here")
}

pub fn unwrap_match_to_i64(re_match: Option<regex::Match<'_>>) -> i64 {
    re_match.unwrap().as_str().parse().unwrap()
}
