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

namespace l0_battleship
{
class Solution {

    public double getHitProbability(int R, int C, int[,] G)
    {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=3641006936004915
        // Constraints
        //      1 ≤ R,C ≤ 100       R,C is the number of rows,columns
        //      0 ≤ Gi,j ≤ 1
        // Complexity: O(N), where N=R*C

        // Note: the solution prevents over/undersized rows/columns and assumes missing elements are 0
        int ret = 0;
        foreach (int elt in G)
                ret += elt;

        return ret / (double)(R * C);
    }

    class Args
    {
        public int[,] G;
        public double res;
    }

    public static int tests()
    {
        Console.WriteLine("\nl0_battleship");
        var s = new Solution();
        int nb_errors = 0;

        Func<Args, double> _getHitProbability = (Args args) => s.getHitProbability(args.G.GetLength(0), args.G.GetLength(1), args.G);

        var args_list = new Args[] {
            new Args { G=new int[,] {{ 0, 0, 1 }, { 1, 0, 1 } }, res=0.5 },
            new Args { G=new int[,] {{ 1, 1 }, { 1, 1 } }, res=1.0 },
        };

        var nb = 1;
        foreach (Args args in args_list)
        {
            var res = _getHitProbability(args);
            if (Math.Abs(res - args.res) < 0.000001)
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
