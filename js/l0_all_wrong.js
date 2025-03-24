// This was converted from Python to Javascript using https://www.codeconvert.ai/free-converter

function getWrongAnswers(N, C) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=1082217288848574
    // Constraints
    //   1 ≤ N ≤ 100         N is the number of characters of string C
    //   Ci ∈ { "A", "B" }
    // Complexity: O(N)

    return C.slice(0, N).split('').map(c => c === 'A' ? 'B' : 'A').join('');
}

function tests() {
    const fn = (C) => [C.length, C];
    const meta_cases = ["meta", [
        [["ABA"], "BAB"],
        [["BBBBB"], "AAAAA"],
    ]];
    return [getWrongAnswers, fn, [meta_cases]];
}

module.exports = {tests};
