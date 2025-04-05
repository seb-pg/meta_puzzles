
fun main(args: Array<String>) {
    var nb_errors = 0;
    // l0
    nb_errors += l0_abcs.tests();
    nb_errors += l0_all_wrong.tests();
    nb_errors += l0_battleship.tests();
    // l1
    nb_errors += l1_cafeteria.tests();
    nb_errors += l1_director_photography1.tests();
    nb_errors += l1_kaitenzushi.tests();
    nb_errors += l1_rotary_lock1.tests();
    nb_errors += l1_scoreboard_interference1.tests();
    nb_errors += l1_stack_stabilization1.tests();
    nb_errors += l1_uniform_integers.tests();
    // l2
    nb_errors += l2_director_photography2.tests();
    nb_errors += l2_hops.tests();
    nb_errors += l2_missing_mail.tests();
    nb_errors += l2_portals.tests();
    nb_errors += l2_rabbit_hole1.tests();
    nb_errors += l2_rotary_lock2.tests();
    nb_errors += l2_scoreboard_interference2.tests();
    nb_errors += l2_tunnel_time.tests();
    // l3
    nb_errors += l3_boss_fight.tests();
    nb_errors += l3_rabbit_hole2.tests();  // FIXME: You solved 15 / 22 test cases. Runtime Error on 7 test cases
    nb_errors += l3_slippery_strip.tests();  // FIXME: You solved 34 / 35 test cases. Time Limit Exceeded on 1 test case
    nb_errors += l3_stack_stabilization2.tests();
    // l4
    nb_errors += l4_conveyor_chaos.tests();  // FIXME: You solved 17 / 19 test cases. Runtime Error on 2 test cases
    //nb_errors += l4_mathematical_art.tests();  // TODO

    println("\n${nb_errors} errors found");
}
