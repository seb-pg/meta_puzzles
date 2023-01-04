#![allow(non_snake_case)]

trait Both {
    fn both(&self) -> f64;
}

struct Result {
    mail_room_value: f64,
    total_value: f64,
}

impl Both for Result {
    fn both(&self) -> f64 {
        return self.mail_room_value + self.total_value;
    }
}

pub fn getMaxExpectedProfit(_N: i32, V: &Vec<i32>, C: i32, S: f64) -> f64 {
    if S == 0.0 {
        let mut ret: f64 = 0.0;
        for &Vi in V {
            ret += Vi as f64;

        }
        return ret - C as f64;
    }

    // Initial result
    let mut results = Vec::<Result>::with_capacity(V.len());
    results.push(Result{ mail_room_value: 0.0, total_value: 0.0 });
    for &Vi in V {
        // Update the best results for the new day, considering the packages could've stolen in previous round
        for result in &mut results {
            result.mail_room_value *= 1.0 - S;
        }

        // Possibility #1 : pick up packages on this day
        // We need to add the best(max) possible total_value among all saved so far
        let pickup_value = (Vi - C) as f64 + results.iter().fold(f64::MIN, |a, b| a.max(b.both()));

        // Possibility #2 : do not pick up packages on this day
        for result in &mut results {
            result.mail_room_value += Vi as f64;
        }

        results.push(Result{ mail_room_value: 0.0, total_value: pickup_value });

    }

    return results.iter().fold(f64::MIN, |a, b| a.max(b.total_value));
}
