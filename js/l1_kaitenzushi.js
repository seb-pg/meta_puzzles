// This was converted from Python to Javascript using https://www.codeconvert.ai/

function getMaximumEatenDishCount(N, D, K) {
    // Constraints
    //   1 ≤ N ≤ 500,000         N is the number of dishes
    //   1 ≤ K ≤ N               K is the number of previous dishes needed to be different
    //   1 ≤ Di ≤ 1,000,000      Di is a dish
    // Complexity: O(N) ~ O(max(N, 1_000_001))   (as asymptotically, N -> +inf)

    // The following is O(1_000_001)
    const eaten = new Array(1000001).fill(false); // we could use bitwise operation in c++ (std::vector<bool>)

    // The following is O(K) (where K < N)
    const lastEaten = new Array(K).fill(0); // circular buffer for last eaten value (0 is not used, as 1 <= Ki <= 1,000,000)
    let oldestEaten = 0;

    // The following is O(N)
    let nb = 0;
    for (let dish of D.slice(0, N)) {
        if (!eaten[dish]) {
            oldestEaten = (oldestEaten + 1) % K;
            const lastEatenDish = lastEaten[oldestEaten];
            eaten[lastEatenDish] = false; // we remove the oldest eaten dish
            eaten[dish] = true;
            lastEaten[oldestEaten] = dish; // we add the newest eaten dish to our circular buffer
            nb += 1;
        }
    }
    return nb;
}

function tests() {
    const fn = (D, K) => [D.length, D, K];
    const metaCases = ["meta", [
        // codeconvert: did not transform correctly tuples
        // converted [[1, 2, 3, 3, 2, 1], 1, 5],
        // fixed     [[[1, 2, 3, 3, 2, 1], 1], 5],
        [[[1, 2, 3, 3, 2, 1], 1], 5],
        [[[1, 2, 3, 3, 2, 1], 2], 4],
        [[[1, 2, 1, 2, 1, 2, 1], 2], 2],
    ]];
    return [getMaximumEatenDishCount, fn, [metaCases]];
}

module.exports = {tests};
