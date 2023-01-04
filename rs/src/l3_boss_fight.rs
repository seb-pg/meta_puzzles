#![allow(non_snake_case)]

type DamageT = u64;

#[derive(Clone)]
struct DamageInfo {
    order: usize,
    indices: [usize; 2],
    damage: DamageT,
}

impl DamageInfo {
    fn new(order: usize) -> DamageInfo {
        DamageInfo{ order, indices: [ 0, 0 ], damage: 0 }
    }
}

fn maximize_damage(N: i32, H: &Vec<i32>, D: &Vec<i32>, info: &mut DamageInfo) -> bool {
    let mut has_same_damage = true;
    for i in 0..N as usize {
        let j = info.indices[info.order];
        let new_damage: DamageT;
        let Hi = H[i] as DamageT;
        let Hj = H[j] as DamageT;
        let Di = D[i] as DamageT;
        let Dj = D[j] as DamageT;
        if info.order == 0 {
            new_damage = Hj * Dj + Hj * Di + Hi * Di;
        }
        else {
            new_damage = Hi * Di + Hi * Dj + Hj * Dj;
        }
        if info.damage < new_damage {
            has_same_damage = false;
            info.damage = new_damage;
            info.indices[1 - info.order] = i;
        }
    }
    return has_same_damage;
}

pub fn getMaxDamageDealt(N: i32, H: &Vec<i32>, D: &Vec<i32>, B: i32) -> f64 {
    let mut damage_infos = Vec::<DamageInfo>::new();
    for order in 0..1 {
        let mut damage_info = DamageInfo::new(order);
        loop {
            let has_same_damage = maximize_damage(N, H, D, &mut damage_info);
            if has_same_damage {
                break;
            }
            damage_info.order = 1 - damage_info.order;
            damage_infos.push(damage_info.clone());
        }
    }

    if damage_infos.is_empty() {
        return 0.0;
    }

    let max_damage = damage_infos.iter().max_by_key(|&x| x.damage).unwrap().damage;
    return (max_damage as f64) / (B as f64);
}
