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

package l0_abcs

fun getSum(A: Int, B: Int, C: Int): Int {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=513411323351554
    // Constraints
    //   1 ≤ A,B,C ≤ 100
    // Complexity: O(1)

	return A + B + C
}

class Args (
	val A: Int,
	val B: Int,
	val C: Int,
	val res: Int) : test.Result<Int> {
	override fun get_result(): Int { return res; };
}

fun tests(): Int
{
	val wrapper = { p: Args -> getSum(p.A, p.B, p.C) };

	val args_list: List<Args> = listOf(
		Args( 1, 2, 3, 6 ),
		Args( 100, 100, 100, 300 ),
		Args( 85, 16, 93, 194 )
	);

	return test.run_all_tests("l0_abcs", args_list, wrapper);
}
