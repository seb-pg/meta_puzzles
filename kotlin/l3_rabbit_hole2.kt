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

package l3_rabbit_hole2

fun getMaxVisitableWebpages(N: Int, M: Int, A: Array<Int>, B: Array<Int>): Int {
    return 0;
}

class Args(
    val A: Array<Int>,
    val B: Array<Int>,
    val res: Int, ) : test.Result<Int> {
    override fun get_result(): Int { return res; };
}

fun tests(): UInt
{
    /*val wrapper = { p: Args -> getMaxVisitableWebpages(p.A, p.B) };

    val args_list: List<Args> = listOf(
        Args( arrayOf(1, 2, 3, 4), arrayOf(4, 1, 2, 1), 4 ),
        Args( arrayOf(3, 5, 3, 1, 3, 2), arrayOf(2, 1, 2, 4, 5, 4), 4 ),
        Args( arrayOf(3, 2, 5, 9, 10, 3, 3, 9, 4), arrayOf(9, 5, 7, 8, 6, 4, 5, 3, 9), 5 ),
        // extra1
        Args( arrayOf(3, 2, 5, 9, 10, 3, 3, 9, 4,  9, 11, 12, 13, 14, 14    ), arrayOf(9, 5, 7, 8,  6, 4, 5, 3, 9, 11, 12,  9,  4,  4,  2    ), 8 ),
        Args( arrayOf(3, 2, 5, 9, 10, 3, 3, 9, 4,  9, 11, 12, 14, 15, 15    ), arrayOf(9, 5, 7, 8,  6, 4, 5, 3, 9, 11, 12,  9,  2,  4,  9    ), 8 ),
        Args( arrayOf(3, 2, 5, 9, 10, 3, 3, 9, 4,  9, 11, 12, 14, 13, 13, 13), arrayOf(9, 5, 7, 8,  6, 4, 5, 3, 9, 11, 12,  9,  2,  4,  5,  8), 8 ),
        Args( arrayOf(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6), arrayOf(3, 4, 3, 4, 5, 6, 5, 6, 7, 8, 7, 8), 4 ),
        Args( arrayOf(1, 3, 2), arrayOf(3, 2, 3), 3 ),
        Args( arrayOf(2, 1), arrayOf(1, 2), 2 ),
        Args( arrayOf(3, 5, 3, 1, 3, 2), arrayOf(2, 2, 2, 4, 5, 4), 4 ),
        Args( arrayOf(3, 5, 3, 1, 3, 2), arrayOf(2, 2, 5, 4, 5, 4), 4 ),  // 3 is referencing twice 5
        Args( arrayOf(3, 5, 3, 1, 3, 2), arrayOf(2, 2, 3, 4, 5, 4), 4 ),  // 3 is self referencing
    );

    return test.run_all_tests("l3_rabbit_hole2", args_list, wrapper);*/
    return 0U;
}

// TODO
