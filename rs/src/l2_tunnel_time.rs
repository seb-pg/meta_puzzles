#![allow(non_snake_case)]

#[derive(Eq)]
struct Tunnel
{
    a: i64,
    b: i64,
}

impl Tunnel {

    fn length(&self) -> i64 {
        return self.b - self.a;
    }
}

impl Ord for Tunnel {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        if self.a < other.a {
            return std::cmp::Ordering::Less;
        }
        else if self.a > other.a {
            return std::cmp::Ordering::Greater;
        }
        if self.b < other.b {
            return std::cmp::Ordering::Less;
        }
        else if self.b > other.b {
            return std::cmp::Ordering::Greater;
        }
        return  std::cmp::Ordering::Equal;
    }
}

impl PartialOrd for Tunnel {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl PartialEq for Tunnel {
    fn eq(&self, other: &Self) -> bool {
        return self.a == other.a && self.b == other.b;
    }
}

pub fn getSecondsElapsed(C: i64, N: i32, A: &Vec<i64>, B: &Vec<i64>, K: i64) -> i64 {
    let mut tunnels = Vec::<Tunnel>::with_capacity(N as usize);
    for (&a, &b) in A.iter().zip(B.iter()) {
        tunnels.push(Tunnel{ a: a, b: b });
    }

    let mut tunnel_time_total: i64 = 0;
    for tunnel in &tunnels {
        tunnel_time_total += tunnel.length();
    }

    let number_of_complete_track: i64 = K as i64 / tunnel_time_total;  // O(1)
    let mut total_time_left: i64 = K - number_of_complete_track * tunnel_time_total;  // O(1)
    let mut travel_time: i64 = number_of_complete_track * C;  // O(1)

    if total_time_left == 0 {
        travel_time -= C - i64::from(*B.iter().min().unwrap());  // O(N)
    }
    else
    {
        tunnels.sort();
        for tunnel in &tunnels {
            let tunnel_length = tunnel.length();
            if tunnel_length >= total_time_left {
                travel_time += tunnel.a + total_time_left;
                break;
            }
            total_time_left -= tunnel_length;
        }
    }
    return travel_time;
}
