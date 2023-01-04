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

namespace l1_cafetaria
{
class Solution {

    public long getMaxAdditionalDinersCount(long N, long K, int M, long[] S) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=203188678289677
        // Constraints
        //      1 ≤ N ≤ 10^15       N is the number of seats
        //      1 ≤ K ≤ N           K is the number of empty seats needed between occupied seats
        //      1 ≤ M ≤ 500,000     M is the number of diners
        //      1 ≤ Si ≤ N          Si is a seat
        // Complexity: O(M*log(M)), but the complexity could be O(M) if S was sorted

        var d = K + 1;
        long[] taken = new long[S.Length + 2];
        taken[0] = -K;
        S.CopyTo(taken, 1);
        taken[^1] = N + d;

        // we sort elements of S: O(M * log(M))
        System.Array.Sort(taken, 1, taken.Length - 1);

        long nb = 0;
        for (int i = 0; i < taken.Length - 1; ++i)
            nb += (taken[i + 1] - taken[i] - d) / d;
        return nb;
    }

}

}
