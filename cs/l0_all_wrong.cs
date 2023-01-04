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

using System.Text;

namespace l0_all_wrong
{
class Solution {

    public string getWrongAnswers(int N, string C) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=1082217288848574
        // Constraints
        //      1 ≤ N ≤ 100         N is the number of characters of string C
        //      Ci ∈ { "A", "B" }
        // Complexity: O(N)

        StringBuilder D = new StringBuilder(C);
        for (int i = 0; i < C.Length; ++i)
            D[i] = D[i] == 'A' ? 'B' : 'A';
        return D.ToString();
    }

}

}
