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

namespace l0_abcs
{
class Solution {
  
    public int getSum(int A, int B, int C) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=513411323351554
        // Constraints
        //   1 ≤ A,B,C ≤ 100
        // Complexity: O(1)

        return A + B + C;
    }

    class Args
    {
        public int A, B, C;
        public int res;
    }

    public static int tests()
    {
        Console.WriteLine("\nl0_abcs");
        var s = new Solution();
        int nb_errors = 0;

        Func<Args, int> _getSum = (Args args) => s.getSum(args.A, args.B, args.C);

        var args_list = new Args[] {
            new Args { A=1, B=2, C=3, res=6 },
            new Args { A=100, B=100, C=100, res=300 },
            new Args { A=85, B=16, C=93, res=194 },
        };

        var nb = 1;
        foreach (Args args in args_list)
        {
            var res = _getSum(args);
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
