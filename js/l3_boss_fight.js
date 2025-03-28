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

class DamageInfo {
    constructor(order = 0, indices = [0, 0], damage = 0) {
        this.order = order;
        this.indices = indices;
        this.damage = damage;
    }
}

function maximizeDamage(N, H, D, info) {
    let hasSameDamage = true;
    for (let i = 0; i < N; i++) {
        const index = info.indices[info.order];
        if (index === i) {
            continue;
        }
        let newDamage;
        if (info.order === 0) {
            newDamage = H[index] * D[index] + H[index] * D[i] + H[i] * D[i];
        } else {
            newDamage = H[i] * D[i] + H[i] * D[index] + H[index] * D[index];
        }
        if (info.damage < newDamage) {
            hasSameDamage = false;
            info.damage = newDamage;
            info.indices[1 - info.order] = i;
        }
    }
    return hasSameDamage;
}

function getMaxDamageDealt(N, H, D, B) {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=149169347195386
    // Constraints :
    //      2 ≤ N  ≤ 500,000
    //      1 ≤ Hi ≤ 1,000,000,000
    //      1 ≤ Di ≤ 1,000,000,000
    //      1 ≤ B  ≤ 1,000,000,000
    // Complexity: O(N^2)

    const damageInfos = [];
    for (let order of [0, 1]) {
        let damageInfo = new DamageInfo(order);
        while (true) {
            const hasSameDamage = maximizeDamage(N, H, D, damageInfo);
            if (hasSameDamage) {
                break;
            }
            damageInfo.order = 1 - damageInfo.order;
            damageInfos.push(new DamageInfo(damageInfo.order, [...damageInfo.indices], damageInfo.damage));
        }
    }
    if (damageInfos.length === 0) {
        return 0.0;
    }
    const damageInfo = damageInfos.reduce((max, d) => d.damage > max.damage ? d : max);
    return damageInfo.damage / B;
}

function tests() {
    const fn = (H, D, B) => [H.length, H, D, B];

    const metaCases = ["meta", [
        [[[2, 1, 4], [3, 1, 2], 4], 6.5],
        [[[1, 1, 2, 100], [1, 2, 1, 3], 8], 62.75],
        [[[1, 1, 2, 3], [1, 2, 1, 100], 8], 62.75],
    ]];
    const extra1Cases = ["extra1", [
        [[[1, 1, 2, 100, 3], [1, 2, 1, 4, 100], 8], 1337.5],
        [[[9, 1, 3, 4], [0, 10, 4, 3], 1], 100.0],
    ]];
    return [getMaxDamageDealt, fn, [metaCases, extra1Cases], (res, exp) => Math.abs(res - exp) < 0.000001];
}

module.exports = {tests};
