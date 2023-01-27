
fun main(args: Array<String>) {
    var nb_errors = 0U;
    // l0
    /*nb_errors += l0_abcs.tests();
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
    nb_errors += l2_portals.tests();  // FIXME: is working, but Meta's website seems to not provide corrupted input test data
    nb_errors += l2_rabbit_hole1.tests();
    nb_errors += l2_rotary_lock2.tests();  // FIXME: is working, but does not pass speed requirement on Meta's website (given 2 other tests seem to be broken on Meta's website...)
    nb_errors += l2_scoreboard_interference2.tests();
    nb_errors += l2_tunnel_time.tests();
    // l3
    nb_errors += l3_boss_fight.tests();
    //nb_errors += l3_rabbit_hole2.tests();  // TODO
    nb_errors += l3_slippery_strip.tests();  // FIXME: is working, but Meta's website seems to not provide corrupted input test data
    nb_errors += l3_stack_stabilization2.tests();*/
    // l4
    nb_errors += l4_conveyor_chaos.tests();  // TODO
    //nb_errors += l4_mathematical_art.tests();  // TODO

    println("\n${nb_errors} errors found");
}
