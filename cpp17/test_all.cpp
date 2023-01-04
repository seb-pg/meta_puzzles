// meta_puzzles by Sebastien Rubens
// This file is part of https://github.com/seb-pg/meta_puzzles
// Please go to https://github.com/seb-pg/meta_puzzles/README.md
// for more information
//
// To the extent possible under law, the person who associated CC0 with
// openmsg has waived all copyright and related or neighboring rights
// to openmsg.
//
// You should have received a copy of the CC0 legalcode along with this
// work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

// We are directly including the .cpp files here
#include "l0_abcs.cpp"
#include "l0_all_wrong.cpp"
#include "l0_battleship.cpp"
#include "l1_cafeteria.cpp"
#include "l1_director_photography1.cpp"
#include "l1_kaitenzushi.cpp"
#include "l1_rotary_lock1.cpp"
#include "l1_scoreboard_interference1.cpp"
#include "l1_stack_stabilization1.cpp"
#include "l1_uniform_integers.cpp"
#include "l2_director_photography2.cpp"
#include "l2_hops.cpp"
#include "l2_missing_mail.cpp"
#include "l2_portals.cpp"
#include "l2_rabbit_hole1.cpp"
#include "l2_rotary_lock2.cpp"
#include "l2_scoreboard_interference2.cpp"
#include "l2_tunnel_time.cpp"
#include "l3_boss_fight.cpp"
#include "l3_rabbit_hole2.cpp"
#include "l3_slippery_strip.cpp"
#include "l3_stack_stabilization2.cpp"
#include "l4_conveyor_chaos.cpp"
#include "l4_mathematical_art.cpp"

#include "test_all.h"


int main(int argc, char* argv[])
{
    (void)argc;
    (void)argv;

    l0_abcs::tests();
    l0_all_wrong::tests();
    l0_battleship::tests();
    l1_cafeteria::tests();
    l1_director_photography1::tests();
    l1_kaitenzushi::tests();
    l1_rotary_lock1::tests();
    l1_scoreboard_interference1::tests();
    l1_stack_stabilization1::tests();
    l1_uniform_integers::tests();
    l2_director_photography2::tests();
    l2_hops::tests();
    l2_missing_mail::tests();
    l2_portals::tests();
    l2_rabbit_hole1::tests();
    l2_rotary_lock2::tests();
    l2_scoreboard_interference2::tests();
    l2_tunnel_time::tests();
    l3_boss_fight::tests();
    l3_rabbit_hole2::tests();
    l3_slippery_strip::tests();
    l3_stack_stabilization2::tests();
    l4_conveyor_chaos::tests();
    l4_mathematical_art::tests();
    return 0;
}


// End
