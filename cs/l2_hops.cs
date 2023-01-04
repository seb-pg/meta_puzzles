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

using System.Linq;

namespace l2_hops
{

class Solution {

    public long getSecondsRequired(long N, int F, long[] P) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=977526253003069
        // Constraints:
        //      2 ≤ N ≤ 10^12
        //      1 ≤ F ≤ 500,000
        //      1 ≤ Pi ≤ N−1
        //      1 ≤ Pi ≤ N−1
        // Complexity: O(N), but could be O(1) if P was sorted

        // When you think about it, the solution is very simple!
        if (P.Length == 0)
            return 0;
        return N - P.Min();
    }
}

}
