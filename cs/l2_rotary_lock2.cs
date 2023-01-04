﻿// meta_puzzles by Sebastien Rubens
// Please go to https://github.com/seb-pg/meta_puzzles/README.md
// for more information
//
// To the extent possible under law, the person who associated CC0 with
// openmsg has waived all copyright and related or neighboring rights
// to openmsg.
//
// You should have received a copy of the CC0 legalcode along with this
// work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

using System;
using System.Collections.Generic;

namespace l2_rotary_lock2
{

class Solution {

    struct Dials
    {
        public int dial1;
        public int dial2;

        public Dials(int _dial1 = 0, int _dial2 = 0)
        {
            dial1 = _dial1;
            dial2 = _dial2;
        }
    }

    static int get_distance(int target, int position, int N)
    {
        var positive_move = (target - position) % N;
        if (positive_move < 0)  // modulo must be positive
            positive_move += N;
        var negative_move = N - positive_move;  // positive number
        return Math.Min(positive_move, negative_move);
    }

    static void insert_solution(Dictionary<Dials, long> new_solutions, int N, int target, int dial1, int dial2, long distance)
    {
        var distance1 = distance + get_distance(target, dial1, N);
        var key1 = new Dials(Math.Min(dial2, target), Math.Max(dial2, target));
        var value1 = new_solutions.ContainsKey(key1) ? new_solutions[key1] : long.MaxValue;
        new_solutions[key1] = Math.Min(value1, distance1);
    }

    public long getMinCodeEntryTime(int N, int M, int[] C) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=1637008989815525
        // Constraints:
        //      3 ≤ N ≤ 1,000,000,000   N is the number of integers
        //      1 ≤ M ≤ 3,000           M is the number of locks
        //      1 ≤ Ci ≤ N              Ci is the combination
        // Complexity: O(M^2)

        if (C.Length == 0)
            return 0;
        var max_value = long.MaxValue;
        var solutions = new Dictionary<Dials, long>();
        solutions[new Dials(1, 1)] = 0;
        foreach (var target in C)
        {
            var new_solutions = new Dictionary<Dials, long>();
            foreach (var dials_distance in solutions)
            {
                var dials = dials_distance.Key;
                var distance = dials_distance.Value;
                // we turn dial1
                insert_solution(new_solutions, N, target, dials.dial1, dials.dial2, distance);
                // we turn dial2
                insert_solution(new_solutions, N, target, dials.dial2, dials.dial1, distance);
            }
            solutions = new_solutions;
        }
        long min_distance = max_value;
        foreach (var dials_distance in solutions)
            min_distance = Math.Min(min_distance, dials_distance.Value);
        return min_distance;
    }
}

}
