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

package l2_rotary_lock2

class Dials(
    var dial1: Int,
    var dial2: Int,
)
{
    companion object
    {
        const val buckets = 1024;
    }

    override fun hashCode(): Int
    {
        return dial1 + dial2;
    }
}

//typealias solutions_t = HashMap<Dials, Long>;  // Does not work on Meta's website
typealias solutions_t = MutableMap<Dials, Long>;  // 30 passed, 32 Time Limit Exceeded

fun get_distance(target: Int, position: Int, N: Int): Int
{
    var positive_move = (target - position) % N;
    if (positive_move < 0)  // modulo must be positive (must check that in C++)
        positive_move += N;
    val negative_move = N - positive_move;  // positive number
    return minOf(positive_move, negative_move);
}

fun insert_solution(new_solutions: solutions_t, N: Int, target: Int, dial1: Int, dial2: Int, distance: Long)
{
    val new_distance = distance + get_distance(target, dial1, N);
    val key = Dials( minOf(dial2, target), maxOf(dial2, target) );
    val it = new_solutions.get(key);
    val value = it ?: Long.MAX_VALUE;
    new_solutions[key] = minOf(value, new_distance);
}

fun getMinCodeEntryTime(N: Int, _M: Int, C: Array<Int>): Long {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=1637008989815525
    // Constraints:
    //      3 ≤ N ≤ 1,000,000,000   N is the number of integers
    //      1 ≤ M ≤ 3,000           M is the number of locks
    //      1 ≤ Ci ≤ N              Ci is the combination
    // Complexity: O(M^2)

    if (C.isEmpty())
        return 0;
    //if (N > 10_000)
    //    return 0;

    //var solutions = solutions_t(Dials.buckets);  // Dials
    var solutions = mutableMapOf<Dials, Long>();  // MutableMap
    solutions[Dials(1, 1)] = 0;
    for (target in C)
    {
        //val new_solutions = solutions_t(Dials.buckets);  // Dials
        var new_solutions = mutableMapOf<Dials, Long>();  // MutableMap
        for ((dials, distance) in solutions)
        {
            // we turn dial1
            insert_solution(new_solutions, N, target, dials.dial1, dials.dial2, distance);
            // we turn dial2
            insert_solution(new_solutions, N, target, dials.dial2, dials.dial1, distance);
        }
        solutions = new_solutions;
    }
    var min_distance = Long.MAX_VALUE;
    for (distance in solutions.values)
        min_distance = minOf(min_distance, distance);
    return min_distance;
}

class Args(
    val N: Int,
    val C: Array<Int>,
    val res: Long) : test.Result<Long> {
    override fun get_result(): Long { return res; };
}

fun tests(): Int
{
    val wrapper = { p: Args -> getMinCodeEntryTime(p.N, p.C.size, p.C) };

    val args_list: List<Args> = listOf(
        Args( 3, arrayOf(1, 2, 3), 2 ),
        Args( 10, arrayOf(9, 4, 4, 8), 6 ),
        // extra1
        Args( 0, arrayOf<Int>(), 0 ),
        Args( 3, arrayOf<Int>(), 0 ),
        Args( 10, arrayOf<Int>(), 0 ),
        Args( 10, arrayOf(4), 3 ),
        Args( 10, arrayOf(9), 2 ),
        Args( 10, arrayOf(9, 9, 9, 9), 2 ),
        // extra2
        Args( 10, arrayOf(6, 2, 4, 8), 10 ),
        Args( 10, arrayOf(10, 9, 8, 7, 6, 5, 4, 3, 2, 1), 9 ),
        Args( 4, arrayOf(4, 3, 2, 1, 2, 3, 4), 5 )
    );

    return test.run_all_tests("l2_rotary_lock2", args_list, wrapper);
}

// FIXME: Meta's website indicate the code is too slow or crashes
