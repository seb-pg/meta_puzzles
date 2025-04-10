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

function getMinimumDeflatedDiscCount(N, R) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=183894130288005
    // Constraints
    //      1 ≤ N  ≤ 50                 N is the number of inflatable discs
    //      1 ≤ Ri ≤ 1,000,000,000      Ri is a disc radius
    // Complexity: O(N)

    const radiuses = R.slice(0, N);
    let nb = 0;
    let current_radius = radiuses[radiuses.length - 1];
    for (let i = radiuses.length - 2; i >= 0; i--) {
        const next_radius = radiuses[i];
        const target_radius = current_radius - 1;
        if (target_radius <= 0) {
            return -1;
        }
        nb += target_radius < next_radius ? 1 : 0;
        current_radius = Math.min(next_radius, target_radius);
    }
    return nb;
}

function tests() {
    const fn = (S) => [S.length, S];
    const meta_cases = ["meta", [
        // codeconvert: did not transform correctly tuples
        [[[2, 5, 3, 6, 5]], 3],
        [[[100, 100, 100]], 2],
        [[[6, 5, 4, 3]], -1],
    ]];
    return [getMinimumDeflatedDiscCount, fn, [meta_cases]];
}

module.exports = {tests};
