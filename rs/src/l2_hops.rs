#![allow(non_snake_case)]

pub fn getSecondsRequired(N: i64, _F: i32, P: &Vec<i32>) -> i64 {
    if P.is_empty() {
        return 0;
    }
    return N - (*P.iter().min().unwrap() as i64);
}
