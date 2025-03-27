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

// This was converted from Python to Javascript using https://www.codeconvert.ai/free-converter

function getHitProbability(R, C, G) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=3641006936004915
    // Constraints
    //   1 ≤ R,C ≤ 100       R,C is the number of rows,columns
    //   0 ≤ Gi,j ≤ 1
    // Complexity: O(N), where N=R*C

    // Note: the solution prevents over/undersized rows/columns and assumes missing elements are 0
    return G.slice(0, R).reduce((sum, row) => sum + row.slice(0, C).reduce((a, b) => a + b, 0), 0) / (R * C);
}

function tests() {
    const fn = (G) => [G.length, G[0].length, G];
    // codeconvert failed to convert tuples
    const meta_cases = ["meta", [
        [[[[0, 0, 1], [1, 0, 1]]], 0.5],
        [[[[1, 1], [1, 1]]], 1.0],
    ]];
    const extra1_cases = ["extra1", [
        [[[[0, 1, 0, 0], [1, 1, 0, 0], [0, 0, 0, 0]]], 0.25],
    ]];
    return [getHitProbability, fn, [meta_cases, extra1_cases], (res, exp) => Math.abs(res - exp) < 0.000001];
}

module.exports = {tests};
