#![allow(non_snake_case)]

pub fn getMinimumSecondsRequired(N: i32, R: &Vec<i32>, A: i32, B: i32) -> i64 {
    use std::cmp;

    if N == 0 || R.is_empty() {
        return 0;
    }

    let mut U = R.clone();

    // Extend the range of input data
    type TotalCostT = i64;
    type UnitCostT = i32;
    let _A = A as TotalCostT;
    let _B = B as TotalCostT;
    let _N = N as usize;

    //
    let mut total_cost: TotalCostT = 0;
    let mut costs = Vec::<UnitCostT>::with_capacity(_N);
    for _ in 0..N {
        costs.push(0);
    }
    let mut intervals = Vec::<usize>::with_capacity(_N);
    intervals.push(0);
    for i in 1.._N {
        let Uj = U[i - 1] + 1;
        let Ui = U[i];
        // inflate first
        if Uj > Ui {  // min_inflate > 0
            let min_inflate = Uj - Ui;  // fits in 32bits
            total_cost += (min_inflate as TotalCostT) * _A;  // fits in 64-bits
            U[i] += min_inflate;  // fits in 32bits by definition
            costs[i] = min_inflate;  // fits in 32bits by definition
        }
        // track continous intervals
        if Uj < Ui {  // min_inflate < 0
            intervals.push(i);
            continue;
        }
        // deflate eventually
        loop {
            let first = *intervals.last().unwrap();
            let nb_tot = 1 + i - first;
            //
            let mut nb_pos = 0;
            let mut min_positive1 = 0;
            for &value in &costs[first..i + 1] {
                if value > 0 {
                    nb_pos += 1;
                    min_positive1 = if min_positive1 > 0 { cmp::min(min_positive1, value) } else { value };
                }
            }
            //
            let min_positive2 = if first > 0  {U[first] - U[first - 1] } else { U[0] };
            let min_positive = cmp::min(min_positive1, min_positive2 - 1);
            let nb_neg = nb_tot - nb_pos;
            let cost_change = ((nb_neg as TotalCostT) * _B - (nb_pos as TotalCostT) * _A) * (min_positive as TotalCostT);
            if cost_change >= 0 {
                break;
            }
            total_cost += cost_change;
            for j in first..i + 1 {
                costs[j] -= min_positive;
                U[j] -= min_positive;
            }
            if first > 0 {
                if U[first] == U[first - 1] + 1 {
                    intervals.pop();
                }
            }
            if min_positive <= 0 {
                break;
            }
        }
    }
    return total_cost;
}
