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

namespace l1_uniform_integers
{

class Solution {

     public int getMinimumDeflatedDiscCount(int N, int[] R) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=183894130288005
        // Constraints
        //      1 ≤ N  ≤ 50                 N is the number of inflatable discs
        //      1 ≤ Ri ≤ 1,000,000,000      Ri is a disc radius
        // Complexity: O(N)

        // FIMXE: use iterators?
        int nb = 0;
        int it = R.Length - 1;
        var current_radius = R[it--];
        for (; it != -1; --it)
        {
            var next_radius = R[it];
            var target_radius = current_radius - 1;
            if (target_radius <= 0)
                return -1;
            nb += target_radius < next_radius ? 1 : 0;
            current_radius = Math.Min(next_radius, target_radius);
        }
        return nb;
    }


}

}
