mod l0_abc;
mod l0_all_wrong;
mod l0_battleship;

mod l1_cafeteria;
mod l1_director_photography1;
mod l1_kaitenzushi;
mod l1_rotary_lock1;
mod l1_scoreboard_interference1;
mod l1_stack_stabilization1;
mod l1_uniform_integers;

mod l2_director_photography2;
mod l2_hops;
mod l2_missing_mail;
mod l2_portals;
mod l2_rotary_lock2;
mod l2_scoreboard_interference2;
mod l2_tunnel_time;

mod l3_boss_fight;
mod l3_slippery_strip;
mod l3_stack_stabilization2;

#[allow(non_snake_case)]
fn main() {
    // The Rust version is based on the C++17 version
    // The tests are minimum for now, and
    // not all puzzles solutions have been published yet
    {
        println!("l0_abc");
        let r0 = l0_abc::getSum(2, 3, 4);
        println!("ret= {}, expected {}\n", r0, 9);
    }
    {
        println!("l0_all_wrong");
        let r0 = l0_all_wrong::getWrongAnswers(4, "ABBA");
        println!("ret= {}, expected {}\n", r0, "BAAB");
    }
    {
        println!("l0_battleship");
        let G: Vec<Vec<i32>> = vec![ vec![ 0, 0, 1 ], vec![ 1, 0, 1 ] ];
        let r0 = l0_battleship::getHitProbability(2, 3, &G);
        println!("ret= {}, expected {}\n", r0, 0.5);
    }
    {
        println!("l1_cafeteria");
        let S: Vec<i64> = vec![ 2, 6 ];
        let r0 = l1_cafeteria::getMaxAdditionalDinersCount(10, 1, S.len() as i32, &S);
        println!("ret= {}, expected {}\n", r0, 3);
    }
    {
        println!("l1_director_photography1");
        let C = ".PBAAP.B";
        let r0 = l1_director_photography1::getArtisticPhotographCount(C.len() as i32, &C, 1, 3);
        println!("ret= {}, expected {}\n", r0, 3);
    }
    {
        println!("l1_kaitenzushi");
        let D: Vec<i32> = vec![ 1, 2, 3, 3, 2, 1 ];
        let r0 = l1_kaitenzushi::getMaximumEatenDishCount(D.len() as i32, &D, 1);
        println!("ret= {}, expected {}\n", r0, 5);
    }
    {
        println!("l1_rotary_lock1");
        let C: Vec<i32> = vec![ 1, 2, 3 ];
        let r0 = l1_rotary_lock1::getMinCodeEntryTime(3, C.len() as i32, &C);
        println!("ret= {}, expected {}\n", r0, 2);
    }
    {
        println!("l1_scoreboard_interference1");
        let S: Vec<i32> = vec![ 1, 2, 3, 4, 5, 6 ];
        let r0 = l1_scoreboard_interference1::getMinProblemCount(S.len() as i32, &S);
        println!("ret= {}, expected {}\n", r0, 4);
    }
    {
        println!("l1_stack_stabilization1");
        let R: Vec<i32> = vec![ 2, 5, 3, 6, 5 ];
        let r0 = l1_stack_stabilization1::getMinimumDeflatedDiscCount(R.len() as i32, &R);
        println!("ret= {}, expected {}\n", r0, 3);
    }
    {
        println!("l1_uniform_integers");
        let r0 = l1_uniform_integers::getMinimumDeflatedDiscCount(75, 300);
        println!("ret= {}, expected {}\n", r0, 5);
    }
    {
        println!("l2_director_photography2");
        let C = "PP.A.BB.B";
        let r0 = l2_director_photography2::getArtisticPhotographCount(C.len() as i32, &C, 1, 3);
        println!("ret= {}, expected {}\n", r0, 4);
    }
    {
        println!("l2_hops");
        let P: Vec<i32> = vec![ 5, 2, 4 ];
        let r0 = l2_hops::getSecondsRequired(6, P.len() as i32, &P);
        println!("ret= {}, expected {}\n", r0, 4);
    }
    {
        println!("l2_missing_mail");
        let V: Vec<i32> = vec![ 10, 2, 8, 6, 4 ];
        let r0 = l2_missing_mail::getMaxExpectedProfit(V.len() as i32, &V, 5, 0.0);
        println!("ret= {}, expected {}", r0, 25.0);

        let V: Vec<i32> = vec![ 10, 2, 8, 6, 4 ];
        let r0 = l2_missing_mail::getMaxExpectedProfit(V.len() as i32, &V, 3, 0.15);
        println!("ret= {}, expected {}\n", r0, 20.10825);
    }
    {
        println!("l2_portals");
        let C: Vec<String> = vec![ String::from("xS..x..Ex") ];
        let r0 = l2_portals::_getSecondsRequired(&C);
        println!("ret= {}, expected {}\n", r0, 3);
    }
    {
        println!("l2_rotary_lock2");
        let C: Vec<i32> = vec![ 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 ];
        let r0 = l2_rotary_lock2::getMinCodeEntryTime(10, C.len() as i32, &C);
        println!("ret= {}, expected {}\n", r0, 9);
    }
    {
        println!("l2_scoreboard_interference2");
        let S: Vec<i32> = vec![ 1, 2, 3, 4, 5 ];
        let r0 = l2_scoreboard_interference2::getMinProblemCount(S.len() as i32, &S);
        println!("ret= {}, expected {}\n", r0, 3);
    }
    {
        println!("l2_tunnel_time");
        let A: Vec<i64> = vec![ 19, 28, 39 ];
        let B: Vec<i64> = vec![ 27, 35, 49 ];
        let r0 = l2_tunnel_time::getSecondsElapsed(50, A.len() as i32, &A, &B, 26);
        println!("ret= {}, expected {}\n", r0, 70);
    }
    {
        println!("l3_boss_fight");
        let H: Vec<i32> = vec![ 2, 1, 4 ];
        let D: Vec<i32> = vec![ 3, 1, 2 ];
        let r0 = l3_boss_fight::getMaxDamageDealt(H.len() as i32, &H, &D, 4);
        println!("ret= {}, expected {}\n", r0, 6.5);
    }
    {
        println!("l3_slippery_strip");
        let R: Vec<String> = vec![ String::from(">*v*>*"), String::from("*v*v>*"), String::from(".*>..*"), String::from(".*..*v") ];
        let r0 = l3_slippery_strip::_getMaxCollectableCoins(&R);
        println!("ret= {}, expected {}", r0, 6);

        let R: Vec<String> = vec![ String::from("******"), String::from("......"), String::from(">*>vvv"), String::from("......") ];
        let r0 = l3_slippery_strip::_getMaxCollectableCoins(&R);
        println!("ret= {}, expected {}\n", r0, 2);
    }
    {
        println!("l3_stack_stabilization2");
        let R: Vec<i32> = vec![ 1_000_000_000, 500_000_000, 200_000_000, 1_000_000 ];
        let r0 = l3_stack_stabilization2::getMinimumSecondsRequired(R.len() as i32, &R, 1, 4);
        println!("ret= {}, expected {}\n", r0, 2_299_000_006 as i64);
    }
}
