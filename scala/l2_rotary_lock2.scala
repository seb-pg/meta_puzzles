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

import scala.collection.immutable.TreeMap

class Dials( var dial1: Int,
             var dial2: Int) extends Ordered[Dials] {
    def compare(rhs: Dials) = if (dial1 != rhs.dial1) (dial1 compare (rhs.dial1)) else (dial2 compare (rhs.dial2))
}

object Solution {
    def getMinCodeEntryTime(N: Int, M: Int, C: Array[Int]): Long = {
        type solutions_t = TreeMap[Dials, Long]

        def get_distance(target: Int, position: Int, N: Int): Int = {
            var positive_move = (target - position) % N
            if (positive_move < 0) { // modulo must be positive (must check that in C++)
                positive_move += N
            }
            val negative_move = N - positive_move // positive number
            return positive_move.min(negative_move)
        }

        def insert_solution(new_solutions: solutions_t, N: Int, target: Int, dial1: Int, dial2: Int, distance: Long): solutions_t = {
            val new_distance = distance + get_distance(target, dial1, N)
            val key = new Dials(dial2.min(target), dial2.max(target))
            val it = new_solutions.get(key)
            val value = it match {
                case Some(it) => it
                case None => Long.MaxValue
            }
            return new_solutions.updated(key, value.min(new_distance))
        }

        if (C.isEmpty) {
            return 0
        }

        var solutions = TreeMap[Dials, Long](new Dials(1, 1) -> 0)
        for (target <- C)
        {
            var new_solutions = TreeMap[Dials, Long]()
            for ((dials, distance) <- solutions)
            {
                // we turn dial1
                new_solutions = insert_solution(new_solutions, N, target, dials.dial1, dials.dial2, distance)
                // we turn dial2
                new_solutions = insert_solution(new_solutions, N, target, dials.dial2, dials.dial1, distance)
            }
            solutions = new_solutions
        }
        var min_distance = Long.MaxValue
        for (distance <- solutions.values)
            min_distance = min_distance.min(distance)
        return min_distance
    }


    class Args(
        val N: Int,
        val C: Array[Int],
        val res: Long ) extends test.Result[Long] {
        override def get_result(): Long = res
    }

    def tests(): Int =
    {
        val wrapper = (p: Args) => getMinCodeEntryTime(p.N, p.C.size, p.C)

        val args_list = Array[Args](
            Args( 3, Array[Int](1, 2, 3), 2 ),
            Args( 10, Array[Int](9, 4, 4, 8), 6 ),
            // extra1
            Args( 0, Array[Int](), 0 ),
            Args( 3, Array[Int](), 0 ),
            Args( 10, Array[Int](), 0 ),
            Args( 10, Array[Int](4), 3 ),
            Args( 10, Array[Int](9), 2 ),
            Args( 10, Array[Int](9, 9, 9, 9), 2 ),
            // extra2
            Args( 10, Array[Int](6, 2, 4, 8), 10 ),
            Args( 10, Array[Int](10, 9, 8, 7, 6, 5, 4, 3, 2, 1), 9 ),
            Args( 4, Array[Int](4, 3, 2, 1, 2, 3, 4), 5 ),
        )

        return test.TestAll().run_all_tests("l2_rotary_lock2", args_list, wrapper)
    }
}
