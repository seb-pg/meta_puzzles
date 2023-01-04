#![allow(non_snake_case)]

pub fn getMaximumEatenDishCount(_N: i32, D: &Vec<i32>, K: i32) -> i32 {
    // The following is O(1_000_001)
    let mut eaten: Vec<bool> = vec![false; 1_000_001];

    // The following is O(K) (where K < N)
    let mut last_eaten: Vec<usize> = vec![0; K as usize];  // circular buffer for last eaten value (0 is not used, as 1 <= Ki <= 1,000,000)
    let mut oldest_eaten: usize = 0;

    // The following is O(N)
    let mut nb: i32 = 0;
    for &_dish in D {
        let dish: usize = _dish as usize;
        if !eaten[dish] {
            oldest_eaten = (oldest_eaten + 1) % (K as usize);
            let last_eaten_dish = last_eaten[oldest_eaten];
            eaten[last_eaten_dish] = false;  // we remove the oldest eaten dish
            eaten[dish] = true;
            last_eaten[oldest_eaten] = dish as usize;  // we add the newest eaten dish to our circular buffer
            nb += 1;
        }
    }
    return nb;
}
