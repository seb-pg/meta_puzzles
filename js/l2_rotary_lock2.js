// This was converted from Python to Javascript using https://www.codeconvert.ai/

function getDistance(target, position, N) {
    // code convert does not deal with modulo the same way as the reference code
    //const positiveMove = (target - position) % N;
    let positiveMove = 0;
    if (target > position) {
        positiveMove = (target - position) % N;
    } else {
        positiveMove = (position - target) % N;
    }
    const negativeMove = N - positiveMove; // positive number
    return Math.min(positiveMove, negativeMove);
}

function getMinCodeEntryTime(N, M, C) {
    // Constraints:
    //   3 ≤ N ≤ 1,000,000,000   N is the number of integers
    //   1 ≤ M ≤ 3,000           M is the number of locks
    //   1 ≤ Ci ≤ N              Ci is the combination
    // Complexity: O(M^2)

    if (C.length === 0) {
        return 0;
    }
    const solutions = new Map();
    solutions.set(JSON.stringify([1, 1]), 0);
    
    for (let i = 0; i < Math.min(M, C.length); i++) { // M iterations
        const target = C[i];
        const newSolutions = new Map();
        
        for (const [key, distance] of solutions) { // 2*M iterations at most
            const [dial1, dial2] = JSON.parse(key);
            
            // we turn dial1
            const distance1 = distance + getDistance(target, dial1, N);
            const key1 = JSON.stringify([Math.min(dial2, target), Math.max(dial2, target)]);
            newSolutions.set(key1, Math.min(newSolutions.get(key1) || Infinity, distance1));
            
            // we turn dial2
            const distance2 = distance + getDistance(target, dial2, N);
            const key2 = JSON.stringify([Math.min(dial1, target), Math.max(dial1, target)]);
            newSolutions.set(key2, Math.min(newSolutions.get(key2) || Infinity, distance2));
        }
        solutions.clear();
        for (const [key, value] of newSolutions) {
            solutions.set(key, value);
        }
    }
    return Math.min(...Array.from(solutions.values()));
}

function tests() {
    const fn = (N, C) => [N, C.length, C];
    const metaCases = ["meta", [
        [[3, [1, 2, 3]], 2],
        [[10, [9, 4, 4, 8]], 6],
    ]];
    const extra1Cases = ["extra1", [
        [[0, []], 0],
        [[3, []], 0],
        [[10, []], 0],
        [[10, [4]], 3],
        [[10, [9]], 2],
        [[10, [9, 9, 9, 9]], 2],
    ]];
    const extra2Cases = ["extra2", [
        [[10, [6, 2, 4, 8]], 10],
        [[10, [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]], 9],
        [[4, [4, 3, 2, 1, 2, 3, 4]], 5],
    ]];
    return [getMinCodeEntryTime, fn, [metaCases, extra1Cases, extra2Cases]];
}

module.exports = {tests};
