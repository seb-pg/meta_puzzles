// meta_puzzles by Sebastien Rubens
//
// Please go to https://github.com/seb-pg/meta_puzzles/README.md
// for more information
//
// To the extent possible under law, the person who associated CC0 with
// meta_puzzles has waived all copyright and related or neighboring rights
// to meta_puzzles.
//
// You should have received a copy of the CC0 legalcode along with this
// work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

// This was converted from Python to Javascript using https://www.codeconvert.ai/

function getMaxExpectedProfit(N, V, C, S) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=401886137594615
    // Constraints:
    //      1   ≤ N  ≤ 4,000    N is the number of parcels
    //      0   ≤ Vi ≤ 1,000    Vi is the value of a parcel
    //      1   ≤ C  ≤ 1,000    C is the cost the enter a room
    //      0.0 ≤ S   ≤ 1.0     S is the probability the content of the mailroom is stolen
    // Complexity: O(N^2)

    V = V.slice(0, N);

    // Optimisation when packages are never stolen (O(N))
    if (S === 0) {
        return V.reduce((a, b) => a + b, 0) - C;
    }

    // Initial solution
    let solutions = [[0, 0]];  // (mail_room_value, total_value)

    for (let Vi of V) {
        // Update the best solutions for the new day, considering the packages could've stolen in previous round
        solutions = solutions.map(([mail_room_value, total_value]) => [mail_room_value * (1 - S), total_value]);

        // Possibility #1 : pick up packages on this day
        // We need to add the best (max) possible total_value among all saved so far
        let pickup_value = Vi - C + Math.max(...solutions.map(([mail_room_value, total_value]) => mail_room_value + total_value));

        // Possibility #2 : do not pick up packages on this day
        solutions = solutions.map(([mail_room_value, total_value]) => [mail_room_value + Vi, total_value]);

        solutions.push([0, pickup_value]);
    }

    return Math.max(...solutions.map(([mail_room_value, total_value]) => total_value));
}

function tests() {
    const fn = (V, C, S) => [V.length, V, C, S];
    const meta_cases = ["meta", [
        [[[10, 2, 8, 6, 4], 5, 0.0], 25.],
        [[[10, 2, 8, 6, 4], 5, 1.0], 9.],
        [[[10, 2, 8, 6, 4], 3, 0.5], 17.],
        [[[10, 2, 8, 6, 4], 3, 0.15], 20.10825],
    ]];
    return [getMaxExpectedProfit, fn, [meta_cases], (res, exp) => Math.abs(res - exp) < 0.000001];
}

module.exports = {tests};
