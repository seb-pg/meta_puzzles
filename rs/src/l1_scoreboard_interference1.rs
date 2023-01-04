#![allow(non_snake_case)]

pub fn getMinProblemCount(_N: i32, S: &Vec<i32>) -> i32 {
    use std::cmp;

    let mut min_number_of_twos: i32 = 0;
    let mut min_number_of_ones: i32 = 0;
    for &score in S {
        let number_of_twos = score / 2;
        let number_of_ones = score % 2;
        min_number_of_twos = cmp::max(min_number_of_twos, number_of_twos);
        min_number_of_ones = cmp::max(min_number_of_ones, number_of_ones);
    }
    return min_number_of_twos + min_number_of_ones;
}
