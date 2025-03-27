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

function getMinimumSecondsRequired(N, R, A, B) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=290955626029019
    // Constraints :
    //      1 ≤ N    ≤ 50
    //      1 ≤ Ri   ≤ 1,000,000,000
    //      1 ≤ A, B ≤ 100
    // Complexity: O(N ^ 2)

    if (N === 0 || R.length === 0) {
        return 0;
    }
    let cost = 0;
    let costs = new Array(N).fill(0);
    let intervals = [0];
    for (let i = 1; i < N; i++) {
        let min_inflate = R[i - 1] + 1 - R[i];
        if (min_inflate > 0) {
            cost += min_inflate * A;
            R[i] += min_inflate;
            costs[i] = min_inflate;
        }
        if (min_inflate < 0) {
            intervals.push(i);
            continue;
        }
        while (true) {
            let first = intervals[intervals.length - 1];
            let nb_tot = i + 1 - first;
            let nb_pos = 0, min_pos1 = 0;
            for (let value of costs.slice(first, i + 1)) {
                if (value > 0) {
                    nb_pos += 1;
                    min_pos1 = (min_pos1 > 0) ? Math.min(min_pos1, value) : value;
                }
            }
            let min_pos2 = (first > 0) ? R[first] - R[first - 1] : R[0];
            let min_pos = Math.min(min_pos1, min_pos2 - 1);
            let nb_neg = nb_tot - nb_pos;
            let cost_change = (nb_neg * B - nb_pos * A) * min_pos;
            if (cost_change > 0) {
                break;
            }
            cost += cost_change;
            for (let j = first; j <= i; j++) {
                costs[j] -= min_pos;
                R[j] -= min_pos;
            }
            if (first > 0) {
                if (R[first] === R[first - 1] + 1) {
                    intervals.pop();
                }
            }
            if (min_pos <= 0) {
                break;
            }
        }
    }
    return cost;
}

function tests() {
    function fn(R, A, B) {
        return [R.length, R, A, B];
    }

    const meta_cases = ["meta", [
        [[[2, 5, 3, 6, 5], 1, 1], 5],
        [[[100, 100, 100], 2, 3], 5],
        [[[100, 100, 100], 7, 3], 9],
        [[[6, 5, 4, 3], 10, 1], 19],
        [[[100, 100, 1, 1], 2, 1], 207],
        [[[6, 5, 2, 4, 4, 7], 1, 1], 10],
    ]];
    const extra1_cases = ["extra1", [
        [[[10, 6, 2], 2, 1], 15],
        [[[1, 2, 3, 4, 5, 6], 1, 1], 0],
        [[[6, 5, 4, 3, 2, 1], 1, 1], 18],
    ]];
    const extra2_cases = ["extra2", [
        [[[4, 6, 2], 2, 1], 9],
        [[[6, 5, 2, 4, 4, 7], 1, 1], 10],
        [[[2, 5, 3, 6, 5], 1, 1], 5],
        [[[2, 3, 8, 1, 7, 6], 2, 1], 15],
        [[[5, 4, 3, 6, 8, 1, 10, 11, 6, 1], 4, 1], 85],
        [[[3, 4, 7, 8, 2], 4, 1], 24],
        [[[1, 1, 1, 1, 1], 4, 1], 40],
        [[[1, 1, 1, 1, 1], 1, 4], 10],
        [[[8, 6, 4, 2], 1, 4], 18],
        [[[1000000000, 500000000, 200000000, 1000000], 1, 4], 2299000006],
    ]];
    return [getMinimumSecondsRequired, fn, [meta_cases, extra1_cases, extra2_cases]];
}

module.exports = {tests};
