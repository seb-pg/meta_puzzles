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
using System.Linq;

namespace l1_kaitenzushi
{

class Solution {

    public int getMaximumEatenDishCount(int N, int[] D, int K) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=958513514962507
        // Constraints
        //      1 ≤ N ≤ 500,000         N is the number of dishes
        //      1 ≤ K ≤ N               K is the number of previous dishes needed to be different
        //      1 ≤ Di ≤ 1,000,000      Di is a dish
        // Complexity: O(N) ~ O(max(N, 1_000_001))   (as asymptotically, N -> +inf)

        // The following is O(1_000_001)
        var eaten = Enumerable.Repeat<bool>(false, 1_000_001).ToArray();

        // The following is O(K) (where K < N)
        var last_eaten = Enumerable.Repeat<int>(0, K).ToArray();
        int oldest_eaten = 0;

        // The following is O(N)
        int nb = 0;
        foreach (var dish in D)
        {
            if (!eaten[dish])
            {
                oldest_eaten = (oldest_eaten + 1) % K;
                var last_eaten_dish = last_eaten[oldest_eaten];
                eaten[last_eaten_dish] = false;  // we remove the oldest eaten dish
                eaten[dish] = true;
                last_eaten[oldest_eaten] = dish;  // we add the newest eaten dish to our circular buffer
                ++nb;
            }
        }
        return nb;
    }

    class Args
    {
        public int[] D;
        public int K;
        public int res;
    }

    public static int tests()
    {
        Console.WriteLine("\nl1_kaitenzushi");
        var s = new Solution();
        int nb_errors = 0;

        Func<Args, double> _getMaximumEatenDishCount = (Args args) => s.getMaximumEatenDishCount(args.D.Length, args.D, args.K);

        var args_list = new Args[] {
            new Args { D=new int[] { 1, 2, 3, 3, 2, 1 }, K=1, res=5 },
            new Args { D=new int[] { 1, 2, 3, 3, 2, 1 }, K=2, res=4 },
            new Args { D=new int[] { 1, 2, 1, 2, 1, 2, 1 }, K=2, res=2 },
        };

        var nb = 1;
        foreach (Args args in args_list)
        {
            var res = _getMaximumEatenDishCount(args);
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
