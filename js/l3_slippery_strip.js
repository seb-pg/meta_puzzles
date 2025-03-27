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

function getCounts(row, counts) {
    counts['*'] = 0;
    counts['>'] = 0;
    counts['v'] = 0;
    for (let c of row) {
        let ord_c = c.charCodeAt(0);
        if (ord_c >= 256) {
            ord_c = '.'.charCodeAt(0);
        }
        counts[String.fromCharCode(ord_c)] += 1;
    }
    const count_star = counts['*'];
    const count_right = counts['>'];
    const count_down = counts['v'];
    return [count_star, count_right, count_down];
}

function getNbCoinsRightThenDown3(row, count_down, count_right) {
    if (count_down === 0) {
        return 0;
    }
    const j = row.indexOf('v') + 1;
    const new_row = row.slice(j) + row.slice(0, j);
    let nb_coins_right_then_down = 0;
    let last = 0;
    while (count_right * count_down !== 0) {
        const first = new_row.indexOf('>', last);
        last = new_row.indexOf('v', first) + 1;
        nb_coins_right_then_down = Math.max(nb_coins_right_then_down, (new_row.slice(first, last).match(/\*/g) || []).length);
        count_down -= 1;
        count_right -= (new_row.slice(first, last).match(/>/g) || []).length;
    }
    return nb_coins_right_then_down;
}

function getMaxCollectableCoins(R, C, G) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=2881982598796847
    // Constraints
    //      2 ≤ R, C ≤ 400, 000
    //      R∗C ≤ 800, 000
    //      Gi, j ∈{ ".", "*", ">", "v" }
    //      Complexity: O(N), where N = R * C

    const counts = {};
    let res = 0;
    for (let row of G.reverse()) {
        const [count_star, count_right, count_down] = getCounts(row, counts);
        const nb_coins_immediately_down = Math.min(count_star, 1);
        if (count_right === C) {
            res = 0;
        } else if (count_right === 0) {
            res += nb_coins_immediately_down;
        } else {
            const nb_coins_right_then_down = getNbCoinsRightThenDown3(row, count_down, count_right);
            // codeconvert produced the following:
            //const nb_coins_right_forever = count_star if count_down === 0 ? count_star : 0;
            const nb_coins_right_forever = count_down == 0 ? count_star : 0;
            res = Math.max(nb_coins_immediately_down + res, nb_coins_right_then_down + res, nb_coins_right_forever);
        }
    }
    return res;
}

function tests() {
    function fn(G) {
        return [G.length, G[0] ? G[0].length : 0, G];
    }

    const meta_cases = ["meta", [
        [[[".***", "**v>", ".*.."]], 4],
        [[[">**", "*>*", "**>"]], 4],
        [[[">>", "**"]], 0],
        [[[">*v*>*", "*v*v>*", ".*>..*", ".*..*v"]], 6],
    ]];
    extra1_cases = ["extra1", [
        [[[]], 0],
        [[["."]], 0],
        [[["v"]], 0],
        [[[">"]], 0],
        [[["*"]], 1],
    ]];
    extra2_cases = ["extra2", [
        [[[".", ".", ">", "*"]], 0],
        [[[".", "*", ">", "*"]], 1],
        [[[".", "*", ">", "."]], 1],
        [[["*", ".", ">", "."]], 1],
        [[["***", "...", ">vv", "..."]], 1],
    ]];
    extra3_cases = ["extra3", [
        [[["*....", ".*...", "..*..", "...*."]], 4],
        [[["....", "....", "....", "...."]], 0],
        [[["***>", "...."]], 3],
        [[["...."]], 0],
        [[["vvvv"]], 0],
        [[["vvvv", "....", ">>>>"]], 0],
    ]];
    extra4_cases = ["extra4", [
        [[["******", "......", ">*>vvv", "......"]], 2],
        [[["*****", ".....", ">>vvv", "....."]], 1],
    ]];
    return [getMaxCollectableCoins, fn, [meta_cases, extra1_cases, extra2_cases, extra3_cases, extra4_cases]];
}

module.exports = {tests};
