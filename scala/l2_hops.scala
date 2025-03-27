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

package l2_hops

object Solution {
    def getSecondsRequired(N: Long, _F: Int, P: Array[Long]): Long = {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=977526253003069
        // Constraints:
        //      2 ≤ N ≤ 10^12
        //      1 ≤ F ≤ 500,000
        //      1 ≤ Pi ≤ N−1
        // Complexity: O(N), but could be O(1) if P was sorted

        if (P.isEmpty)
            return 0
        return N - P.min
    }


    class Args(val N: Long,
               val P: Array[Long],
               val res: Long ) extends test.Result[Long] {
        override def get_result(): Long = res
    }

    def tests(): Int =
    {
        val wrapper = (p: Args) => getSecondsRequired(p.N, p.P.size, p.P)

        val args_list = Array[Args](
            new Args(3, Array[Long](1), 2),
            new Args(6, Array[Long](5, 2, 4), 4)
        )

        return test.TestAll.run_all_tests("l2_hops", args_list, wrapper)
    }
}
