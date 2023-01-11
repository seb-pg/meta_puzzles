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

using System;

namespace l1_scoreboard_interference1
{

class Solution {

    public int getMinProblemCount(int N, int[] S) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=348371419980095
        // Constraints
        //      1 ≤ N ≤ 500,000             N is the number of scores
        //      1 ≤ Si ≤ 1,000,000,000      Si is a score
        // Complexity: O(N)

        // Note: the way to solve this problem is to count and his fairly simple
        // - the minimum number of problems scored 2 to solve all solutions
        // - the minimum number of problems scored 1 to solve all solutions (0 or 1)

        int min_number_of_twos = 0;
        int min_number_of_ones = 0;
        foreach (var score in S)
        {
            var number_of_twos = score / 2;
            var number_of_ones = score % 2;
            min_number_of_twos = Math.Max(min_number_of_twos, number_of_twos);
            min_number_of_ones = Math.Max(min_number_of_ones, number_of_ones);
        }
        return min_number_of_twos + min_number_of_ones;
    }

    class Args
    {
        public int[] S;
        public int res;
    }

    public static int tests()
    {
        Console.WriteLine("\nl1_scoreboard_interference1");
        var s = new Solution();
        int nb_errors = 0;

        Func<Args, double> _getMinProblemCount = (Args args) => s.getMinProblemCount(args.S.Length, args.S);

        var args_list = new Args[] {
            new Args { S=new int[] { 1, 2, 3, 4, 5, 6 }, res=4 },
            new Args { S=new int[] { 4, 3, 3, 4 }, res=3 },
            new Args { S=new int[] { 2, 4, 6, 8 }, res=4 },
        };

        var nb = 1;
        foreach (Args args in args_list)
        {
            var res = _getMinProblemCount(args);
            if (res == args.res)
                Console.WriteLine("  test #{0}: res={1} CORRECT", nb, res);
            else
            {
                Console.WriteLine("  test #{0}: res={1} ERROR <---------------------", nb, res);
                Console.WriteLine("  expected= {0}", args.res);
                nb_errors += 1;
            }
            ++nb;
        }

        return nb_errors;
    }

}

}
