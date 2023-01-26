// meta_puzzles by Sebastien Rubens
//
// Please go to https://github.com/seb-pg/meta_puzzles/README.md
// for more information
//
// To the extent possible under law, the person who associated CC0 with
// meta_puzzles has waived all copyright and related or neighboring rights
// to meta_puzzles.
//
// You should have received a copy of the CC0 legalcode along with this
// work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

package l4_conveyor_chaos

fun getMinExpectedHorizontalTravelDistance(N: Int, H: Array<Int>, A: Array<Int>, B: Array<Int>): Double {
    return 0.0;
}

class Args(
    val H: Array<Int>,
    val A: Array<Int>,
    val B: Array<Int>,
    val res: Double, ) : test.Result<Double> {
    override fun get_result(): Double { return res; };
}

fun tests(): UInt
{
    val wrapper = { p: Args -> getMinExpectedHorizontalTravelDistance(p.A.size, p.H, p.A, p.B) };

    val args_list: List<Args> = listOf(
        Args( arrayOf(10, 20), arrayOf(100_000, 400_000), arrayOf(600_000, 800_000), 155_000.0 ),
        Args( arrayOf(2, 8, 5, 9, 4), arrayOf(5_000, 2_000, 7_000, 9_000, 0), arrayOf(7_000, 8_000, 11_000, 11_000, 4_000), 36.5 ),
        // extra1
        Args( arrayOf(2, 4, 5, 8, 9), arrayOf(5_000, 0, 7_000, 2_000, 9_000), arrayOf(7_000, 4_000, 11_000, 8_000, 11_000), 36.5 ),
        //
        Args( arrayOf(10), arrayOf(0), arrayOf(1_000_000), 500_000.0 ),
        Args( arrayOf(10), arrayOf(0), arrayOf(500_000), 125_000.0 ),
        Args( arrayOf(9), arrayOf(500_000), arrayOf(1_000_000), 125_000.0 ),
        Args( arrayOf(10, 9), arrayOf(0, 500_000), arrayOf(500_000, 1_000_000), 250_000.0 ),
        //
        Args( arrayOf(20, 10), arrayOf(200_000, 400_000), arrayOf(600_000, 800_000), 120_000.0 ),
        Args( arrayOf(20, 10), arrayOf(400_000, 200_000), arrayOf(800_000, 600_000), 120_000.0 ),
        Args( arrayOf(20, 20, 10), arrayOf(100_000, 500_000, 200_000), arrayOf(300_000, 700_000, 600_000), 100_000.0 ),
        //
        Args( arrayOf(1), arrayOf(0), arrayOf(1_000_000), 500_000.0 ),
        Args( arrayOf(1), arrayOf(250_000), arrayOf(750_000), 125_000.0 ),
        Args( arrayOf(1, 3, 3, 5), arrayOf(400_000, 200_000,  600_000, 400_000), arrayOf(700_000, 500_000, 1_000_000, 700_000), 213_750.0 ),
        Args( arrayOf(1, 3, 3, 5, 7), arrayOf(400_000, 200_000,  600_000, 400_000, 400_000), arrayOf(700_000, 500_000, 1000_000, 700_000, 600_000), 215_000.0 ),
    );

    return test.run_all_tests("l4_conveyor_chaos", args_list, wrapper, 0.000_001);
}

// TODO
