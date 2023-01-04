#![allow(non_snake_case)]

pub fn getMinimumDeflatedDiscCount(_N: i32, R: &Vec<i32>) -> i32 {
    use std::cmp;

    let mut nb: i32 = 0;
    let mut iter = R.iter().rev();
    let mut current_radius = *iter.next().unwrap();
    for next_radius in iter {
        let target_radius = current_radius - 1;
        if target_radius <= 0 {
            return -1;
        }
        nb += if target_radius < *next_radius { 1 } else { 0 };
        current_radius = cmp::min(*next_radius, target_radius);
    }
    return nb;
}
