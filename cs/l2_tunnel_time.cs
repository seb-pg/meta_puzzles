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

namespace l2_tunnel_time
{

    struct Tunnel : IComparable<Tunnel>
    {
        public long a;
        public long b;

        public Tunnel(long _a = 0, long _b = 0)
        {
            a = _a;
            b = _b;
        }

        public long length()
        {
            return b - a;
        }

        public int CompareTo(Tunnel other)
        {
            if (a < other.a)
                return -1;
            if (a > other.a)
                return 1;
            if (b < other.b)
                return -1;
            if (b > other.b)
                return 1;
            return 0;
        }
    }

    class Solution {

    public long getSecondsElapsed(long C, int N, long[] A, long[] B, long K) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=1492699897743843
        // Constraints:
        //      3 ≤ C ≤ 10^12       C is the circumference
        //      1 ≤ N ≤ 500,000     N is the number of tunnels
        //      1 ≤ Ai < Bi ≤ C     Ai and Bi are the start and end of the tunnels
        //      1 ≤ K ≤ 10^12       K is the time spent in tunnels
        // Complexity: O(N*log(N)), would be O(N) if tunnels were sorted

        var tunnels = new List<Tunnel>(N);
        for (int i = 0; i < N; ++i)
            tunnels.Add(new Tunnel(A[i], B[i]));

        long tunnel_time_total = 0;
        foreach (Tunnel tunnel in tunnels)
            tunnel_time_total += tunnel.length();  // could use std::views::zip in C++23

        long number_of_complete_track = (K / tunnel_time_total);  // O(1)
        long total_time_left = K - number_of_complete_track * tunnel_time_total;  // O(1)
        long travel_time = number_of_complete_track * C;  // O(1)

        if (total_time_left == 0)
            travel_time -= C - B.Max();  // O(N)
        else
        {
            tunnels.Sort();
            foreach (Tunnel tunnel in tunnels)
            {
                long tunnel_length = tunnel.length();
                if (tunnel_length >= total_time_left)
                {
                    travel_time += tunnel.a + total_time_left;
                    break;
                }
                total_time_left -= tunnel_length;
            }
        }
        return travel_time;
    }

    class Args
    {
        public long C;
        public long[] A;
        public long[] B;
        public long K;
        public int res;
    }

    public static int tests()
    {
        Console.WriteLine("\nl2_tunnel_time");
        var s = new Solution();
        int nb_errors = 0;

        Func<Args, double> _getSecondsElapsed = (Args args) => s.getSecondsElapsed(args.C, args.A.Length, args.A, args.B, args.K);

        var args_list = new Args[] {
            new Args { C=10, A=new long[] { 1, 6 }, B=new long[] { 3, 7 }, K=7, res=22 },
            new Args { C=50, A=new long[] { 39, 19, 28 }, B=new long[] { 49, 27, 35 }, K=15, res=35 },
        };

        var nb = 1;
        foreach (Args args in args_list)
        {
            var res = _getSecondsElapsed(args);
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
