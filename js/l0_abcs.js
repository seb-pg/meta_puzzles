// This was converted from Python to Javascript using https://www.codeconvert.ai/free-converter

function getSum(A, B, C) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=513411323351554
    // Constraints
    //   1 ≤ A,B,C ≤ 100
    // Complexity: O(1)

    return A + B + C;
}

function tests() {
    const fn = (a, b, c) => [a, b, c];
    const meta_cases = ["meta", [
        [[1, 2, 3], 6],
        [[100, 100, 100], 300],
        [[85, 16, 93], 194],
    ]];
    return [getSum, fn, [meta_cases]];
}

module.exports = {tests};
