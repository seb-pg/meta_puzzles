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

function getMinProblemCount(N, S) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=503122501113518
    // Constraints:
    //      1 ≤ N ≤ 500,000
    //      1 ≤ i ≤ 1,000,000,000
    // Complexity: O(N)

    let max_score = 0, second_max_score = 0, two_remainder = 0, one_remainder = 0, need_one = false;
    for (let score of S.slice(0, N)) {
        let score_mod_3 = score % 3;
        two_remainder |= (score_mod_3 >> 1);
        one_remainder |= (score_mod_3 & 1);
        need_one = need_one || (score === 1);
        if (max_score < score) {
            second_max_score = max_score;
            max_score = score;
        } else if (second_max_score < score) {
            second_max_score = score;
        }
    }

    let count = Math.floor(max_score / 3) + two_remainder + one_remainder;

    if (two_remainder * one_remainder !== 1) {
        return count;
    }

    if (max_score % 3 === 0) {
        count -= 1;
    }

    if (need_one) {
        return count;
    }
    if (max_score % 3 !== 1) {
        return count;
    }
    if (![1, 3].includes(max_score - second_max_score)) {
        count -= 1;
    }
    return count;
}

function tests() {
    function fn(S) { return [S.length, S]; }
    const meta_cases = ["meta", [
        [[[1, 2, 3, 4, 5]], 3],
        [[[4, 3, 3, 4]], 2],
        [[[2, 4, 6, 8]], 4],
        [[[8]], 3],
    ]];
    const extra1_cases = ["extra1", [
        [[[1, 2, 3, 4, 5]], 3],
        [[[4, 3, 3, 4]], 2],
        [[[2, 4, 6, 8]], 4],
        [[[8]], 3],
        [[[1, 2, 3]], 2],
        [[[5, 7]], 3],
        [[[5, 9, 10]], 5],
        [[[5, 9, 11]], 4],
        [[[2, 4, 6]], 3],
        [[[2, 4, 7]], 4],
    ]];
    const extra2_cases = ["extra2", [
        [[[1, 2, 4]], 3],
        [[[2, 4]], 2],
        [[[4, 5]], 3],
        [[[9, 12]], 4],
        [[[11, 13]], 5],
    ]];
    return [getMinProblemCount, fn, [meta_cases, extra1_cases, extra2_cases]];
}

module.exports = {tests};
