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
using System.Collections.Generic;
using System.Linq;

namespace l3_boss_fight
{

class Solution {

    class DamageInfo
    {
        public int order;
        public int[] indices;
        public long damage;

        public DamageInfo(int _order = 0)
        {
            order = _order;
            indices = new int[2] { 0, 0 };
            damage = 0;
        }

        public DamageInfo(DamageInfo other)
        {
            order = other.order;
            indices = (int[]) other.indices.Clone();
            damage = other.damage;
        }
    }

    static bool maximize_damage(int N, int[] H, int[] D, ref DamageInfo info)
    {
        // this maximizes damage for a fixed index(max_i if order is True, otherwise max_j)
        // and also returns the value of max_i and max_j
        var has_same_damage = true;
        for (int i = 0; i < N; ++i)
        {
            var j = info.indices[info.order];
            if (j == i)
                continue;
            long new_damage = 0;
            long Hi = H[i];
            long Hj = H[j];
            if (info.order == 0)
                new_damage = Hj * D[j] + Hj * D[i] + Hi * D[i];
            else
                new_damage = Hi * D[i] + Hi * D[j] + Hj * D[j];
            if (info.damage < new_damage)
            {
                has_same_damage = false;
                info.damage = new_damage;
                info.indices[1 - info.order] = i;
            }
        }
        return has_same_damage;
    }

    public double getMaxDamageDealt(int N, int[] H, int[] D, int B) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=149169347195386
        // Constraints :
        //      2 ≤ N  ≤ 500,000
        //      1 ≤ Hi ≤ 1,000,000,000
        //      1 ≤ Di ≤ 1,000,000,000
        //      1 ≤ B  ≤ 1,000,000,000
        // Complexity: O(N^2)

        // we are maximizing H[i] * D[i] + H[i] * D[j] + H[j] * D[j] where i < j

        var damage_infos = new List<DamageInfo>();  // note: no reserve() here
        foreach (var order in new List<int>(2) { 0, 1 })
        {
            var damage_info = new DamageInfo(order);
            while (true)
            {
                var has_same_damage = maximize_damage(N, H, D, ref damage_info);
                if (has_same_damage)
                    break;
                damage_info.order = 1 - damage_info.order;
                damage_infos.Add(new DamageInfo(damage_info));
            }
        }
        if (damage_infos.Count == 0)
            return 0.0;

        var max_damage = damage_infos.Max(obj => obj.damage);
        return max_damage / (double)(B);
    }

    class Args
    {
        public int[] H;
        public int[] D;
        public int B;
        public double res;
    }

    public static int tests()
    {
        Console.WriteLine("\nl3_boss_fight");
        var s = new Solution();
        int nb_errors = 0;

        Func<Args, double> _getMaxDamageDealt = (Args args) => s.getMaxDamageDealt(args.H.Length, args.H, args.D, args.B);

        var args_list = new Args[] {
            new Args { H=new int[] { 2, 1, 4 }, D=new int[] { 3, 1, 2 }, B=4, res=6.5 },
            new Args { H=new int[] { 1, 1, 2, 100 }, D=new int[] { 1, 2, 1, 3 }, B=8, res=62.75 },
            new Args { H=new int[] { 1, 1, 2, 3 }, D=new int[] { 1, 2, 1, 100 }, B=8, res=62.75 },
        };

        var nb = 1;
        foreach (Args args in args_list)
        {
            var res = _getMaxDamageDealt(args);
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
