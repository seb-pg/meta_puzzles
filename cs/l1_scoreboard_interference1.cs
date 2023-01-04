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

}

}
