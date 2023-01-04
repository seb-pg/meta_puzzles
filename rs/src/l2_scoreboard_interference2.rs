﻿#![allow(non_snake_case)]

pub fn getMinProblemCount(_N: i32, S: &Vec<i32>) -> i32 {
    let mut max_score = 0;
    let mut second_max_score = 0;
    let mut two_remainder = 0;
    let mut one_remainder = 0;
    let mut need_one: bool = false;

    for &score in S {
        let score_mod_3 = score % 3;
        two_remainder |= score_mod_3 >> 1;
        one_remainder |= score_mod_3 & 1;
        need_one = need_one || (score == 1);
        if max_score < score {
            second_max_score = max_score;
            max_score = score;
        }
        else if second_max_score < score {
            second_max_score = score;
        }
    }

    // number of solutions, without any optimisation
    let mut count = max_score / 3 + two_remainder + one_remainder;

    // not optimisation is possible if "two_remainder and one_remainder" is not true
    if two_remainder * one_remainder != 1 {
        return count;
    }

    // replace "last +3" by "+1+2"
    if max_score % 3 == 0 {
        count -= 1;
    }

    // replace last "+3+1" by "+2+2"
    if need_one {  // exit early because 1 is required but at least one sum(i.e.it cannot be replaced)
        return count;
    }
    if max_score % 3 != 1 {  // max_score does not have a 1 (so it cannot be replaced)
        return count;
    }
    let tmp =max_score - second_max_score;
    if !(tmp == 1 || tmp == 3) { // [ok, not ok(3), ok] || [not ok(1) | here | unimportant]
        count -= 1;
    }
    return count;
}
