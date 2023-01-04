using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;

namespace main
{

#nullable enable annotations

    struct PointStruct
    {
        public int X;
        public int Y;

        public PointStruct(int _X = 0, int _Y = 0)
        {
            X = _X;
            Y = _Y;
        }
    }

    internal class Program
    {
        static void Main(string[] args)
        {
            {
                var s = new l0_abcs.Solution();
                var ret = s.getSum(1, 2, 3);
                Console.WriteLine(ret);
            }
            {
                var s = new l0_all_wrong.Solution();
                var ret = s.getWrongAnswers(3, "ABA");
                Console.WriteLine(ret);
            }
            {
            }
            {
                var s = new l1_cafetaria.Solution();
                long[] S = { 2, 6 };
                var ret = s.getMaxAdditionalDinersCount(10, 1, 2, S);
                Console.WriteLine(ret);
            }
            //[(10, 1, [2, 6], ), 3]
            {
                var s = new l1_director_photography1.Solution();
                string C = "APABA";
                var ret = s.getArtisticPhotographCount(C.Length, C, 1, 2);
                Console.WriteLine(ret);
            }
            {
                var s = new l1_kaitenzushi.Solution();
                int[] D = { 1, 2, 3, 3, 2, 1 };
                var ret = s.getMaximumEatenDishCount(D.Length, D, 1);
                Console.WriteLine(ret);
            }
            {
                var s = new l2_hops.Solution();
                long[] P = { 5, 2, 4 };
                var ret = s.getSecondsRequired(6, P.Length, P);
                Console.WriteLine(ret);
            }
            {
                var s = new l2_missing_mail.Solution();
                int[] V = { 10, 2, 8, 6, 4 };
                var ret = s.getMaxExpectedProfit(V.Length, V, 3, 0.15);
                Console.WriteLine(ret);  // 20.10825
            }
            {
                var s = new l2_portals.Solution();
                char[,] G = { { '.', 'E', '.' }, { '.', '#', 'E' }, { '.', 'S', '#' } };
                var ret = s.getSecondsRequired(G.GetLength(0), G.GetLength(1), G);
                Console.WriteLine(ret);  // 4
            }
            {
                var s = new l2_portals.Solution();
                char[,] G = { { 'a', '.', 'S', 'a' }, { '#', '#', '#', '#' }, { 'E', 'b', '.', 'b' } };
                var ret = s.getSecondsRequired(G.GetLength(0), G.GetLength(1), G);
                Console.WriteLine(ret);  // -1
            }
            {
                var s = new l2_portals.Solution();
                char[,] G = { { 'a', 'S', '.', 'b' }, { '#', '#', '#', '#' }, { 'E', 'b', '.', 'a' } };
                var ret = s.getSecondsRequired(G.GetLength(0), G.GetLength(1), G);
                Console.WriteLine(ret);  // 4
            }
            {
                var s = new l2_portals.Solution();
                char[,] G = { { 'x', 'S', '.', '.', 'x', '.', '.', 'E', 'x' } };
                var ret = s.getSecondsRequired(G.GetLength(0), G.GetLength(1), G);
                Console.WriteLine(ret);  // 3
            }
            {
                var s = new l2_rotary_lock2.Solution();
                int[] C = { 1, 2, 3 };
                var ret = s.getMinCodeEntryTime(3, C.Length, C);
                Console.WriteLine(ret);  // 2
            }
            {
                var s = new l3_stack_stabilization2.Solution();
                int[] R = { 2, 5, 3, 6, 5 };
                var ret = s.getMinimumSecondsRequired(R.Length, R, 1, 1);
                Console.WriteLine(ret);  // 5
            }
            {
                var s = new l3_boss_fight.Solution();
                int[] H = { 2, 1, 4 };
                int[] D = { 3, 1, 2 };
                var ret = s.getMaxDamageDealt(H.Length, H, D, 4);
                Console.WriteLine(ret);  // 6.5
            }
            {
                var s = new l3_slippery_strip.Solution();
                char[,] G = { { '.', '*', '*', '*' }, { '*', '*', 'v', '>' }, { '.', '*', '.', '.' } };
                var ret = s.getMaxCollectableCoins(G.GetLength(0), G.GetLength(1), G);
                Console.WriteLine(ret);  // 4
            }
            {
                var s = new l3_slippery_strip.Solution();
                char[,] G = { { '>', '*', 'v', '*', '>', '*' }, { '*', 'v', '*', 'v', '>', '*' }, { '.', '*', '>', '.', '.', '*' }, { '.', '*', '.', '.', '*', 'v' } };
                var ret = s.getMaxCollectableCoins(G.GetLength(0), G.GetLength(1), G);
                Console.WriteLine(ret);  // 6
            }
            {
                var s = new l3_rabbit_hole2.Solution();
                int[] A = { 1, 2, 3, 4 };
                int[] B = { 4, 1, 2, 1 };
                var ret = s.getMaxVisitableWebpages(4, A.Length, A, B);
                Console.WriteLine(ret);  // 4
            }
        }
    }
}
