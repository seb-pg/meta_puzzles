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

using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;

namespace l2_missing_mail
{

class Solution {

    struct Result
    {
        public double mail_room_value;
        public double total_value;

        public Result(double _mail_room_value = 0, double _total_value = 0)
        {
            mail_room_value = _mail_room_value;
            total_value = _total_value;
        }

        public double both()
        {
            return mail_room_value + total_value;
        }
    }

    public double getMaxExpectedProfit(int N, int[] V, int C, double S) {
        // https://www.metacareers.com/profile/coding_puzzles/?puzzle=401886137594615
        // Constraints:
        //      1   ≤ N  ≤ 4,000    N is the number of parcels
        //      0   ≤ Vi ≤ 1,000    Vi is the value of a parcel
        //      1   ≤ C  ≤ 1,000    C is the cost the enter a room
        //      0.0 ≤ S   ≤ 1.0     S is the probability the content of the mailroom is stolen
        // Complexity: O(N^2)

        // Optimisation when packages are never stolen (O(N))
        if (S == 0)
            return V.Sum() - C;

        // Initial result
        var results = new List<Result>(V.Length + 1);
        results.Add(new Result());
        foreach (var Vi in V)
        {
            // Update the best results for the new day, considering the packages could've stolen in previous round
            foreach (ref var result in CollectionsMarshal.AsSpan(results))
                result.mail_room_value *= (1 - S);

            // Possibility #1 : pick up packages on this day
            // We need to add the best(max) possible total_value among all saved so far
            var pickup_value = Vi - C + results.Max(obj => obj.both());

            // Possibility #2 : do not pick up packages on this day
            foreach (ref var result in CollectionsMarshal.AsSpan(results))
                result.mail_room_value += Vi;

            results.Add(new Result() { mail_room_value = 0, total_value = pickup_value });
        }

        return results.Max(obj => obj.total_value);
    }
}

}
