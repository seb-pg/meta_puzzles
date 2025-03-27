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

function getUniformIntegerCountInInterval(A, B) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=228269118726856
    // Constraints:
    //      1 ≤ A ≤ B ≤ 10^12
    // Complexity: O(log(max(A, B)))
    //      logarithmic on the number of digits to represent the integers
    //      The python version works using integer<->string conversion, which is not great

    const len_a = String(A).length;
    const len_b = String(B).length;
    const tmp_a = parseInt('1'.repeat(len_a));
    const tmp_b = parseInt('1'.repeat(len_b));

    const nb_a = Math.floor((tmp_a * 10 - A) / tmp_a);
    const nb_b = Math.floor(B / tmp_b);
    const nb_m = (len_b - len_a >= 2) ? 9 * (len_b - len_a - 1) : 0;
    let nb = nb_a + nb_m + nb_b;

    if (len_a === len_b) {
        nb -= 9;
    }
    return nb;
}

function tests() {
    const fn = (A, B) => [A, B];
    const meta_cases = ["meta", [
        [[75, 300], 5],
        [[1, 9], 9],
        [[999999999999, 999999999999], 1],
    ]];
    const extra1_cases = ["extra1", [
        [[1, 1000000000000], 108],
    ]];
    const extra2_cases = ["extra2", [
        [[10, 99], 9],
        [[11, 98], 8],
        [[21, 89], 7],
        [[22, 88], 7],
        [[23, 87], 5],
    ]];
    const extra3_cases = ["extra3", [
        [[11, 88], 8],
        [[11, 98], 8],
        [[11, 99], 9],
    ]];
    return [getUniformIntegerCountInInterval, fn, [meta_cases, extra1_cases, extra2_cases, extra3_cases]];
}

module.exports = {tests};
