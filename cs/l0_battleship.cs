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

}

}
