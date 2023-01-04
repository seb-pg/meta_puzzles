// meta_puzzles by Sebastien Rubens
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

namespace l1_rotary_lock1
{

class Solution {

    public long getMinCodeEntryTime(int N, int M, int[] C) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=990060915068194
        // Constraints
        //      3 ≤ N ≤ 50,000,000      N is the number of integers
        //      1 ≤ M ≤ 1,000           M is the number of locks
        //      1 ≤ Ci ≤ N              Ci is the combination
        // Complexity: O(M)

        // The following is O(N)
        int pos = 1;
        long nb = 0;
        foreach (var target in C)
        {
            var positive_move = (target - pos) % N;  // positive move
            positive_move = positive_move < 0 ? positive_move + N : positive_move;  // modulo can be negative in C++
            var negative_move = N - positive_move;
            nb += Math.Min(positive_move, negative_move);
            pos = target;
        }
        return nb;
    }

}

}
