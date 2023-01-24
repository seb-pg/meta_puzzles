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

#include "test_all.h"

#include <algorithm>
#include <cstdint>  // int**_t
#include <limits>
#include <tuple>
#include <unordered_map>
#include <vector>

namespace l2_rotary_lock2 {

struct Dials
{
    int32_t dial1;
    int32_t dial2;

    bool operator==(const Dials& rhs) const
    {
        return std::tie(dial1, dial2) == std::tie(rhs.dial1, rhs.dial2);
    }
};

}  // namespace l2_rotary_lock2

namespace std
{

template <>
struct hash<l2_rotary_lock2::Dials>
{
    int32_t operator()(const l2_rotary_lock2::Dials& dial) const
    {
        return dial.dial1 ^ dial.dial2;
    }
};

}

namespace l2_rotary_lock2 {

using solutions_t = std::unordered_map<Dials, int64_t>;

static inline int32_t get_distance(int32_t target, int32_t position, int32_t N)
{
    auto positive_move = (target - position) % N;
    if (positive_move < 0)  // modulo must be positive (must check that in C++)
        positive_move += N;
    const auto negative_move = N - positive_move;  // positive number
    return std::min(positive_move, negative_move);
}

static void insert_solution(solutions_t& new_solutions, int32_t N, int32_t target, int32_t dial1, int32_t dial2, int64_t distance)
{
    const auto new_distance = distance + get_distance(target, dial1, N);
    const Dials key = { std::min(dial2, target), std::max(dial2, target) };
    const auto it = new_solutions.find(key);
    const auto value = it == std::end(new_solutions) ? std::numeric_limits<int64_t>::max() : it->second;
    new_solutions[key] = std::min(value, new_distance);
}

long long getMinCodeEntryTimeCpp17(int32_t N, uint32_t M, const std::vector<int32_t>& C)
{
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=1637008989815525
    // Constraints:
    //      3 ≤ N ≤ 1,000,000,000   N is the number of integers
    //      1 ≤ M ≤ 3,000           M is the number of locks
    //      1 ≤ Ci ≤ N              Ci is the combination
    // Complexity: O(M^2)

    (void)M;

    if (C.empty())
        return 0;

    solutions_t solutions = { {{1, 1}, 0} };
    for (const auto& target : C)
    {
        solutions_t new_solutions;
        for (const auto& [dials, distance] : solutions)
        {
            const auto [dial1, dial2] = dials;
            // we turn dial1
            insert_solution(new_solutions, N, target, dial1, dial2, distance);
            // we turn dial2
            insert_solution(new_solutions, N, target, dial2, dial1, distance);
        }
        solutions.swap(new_solutions);
    }
    auto min_distance = std::numeric_limits<solutions_t::mapped_type>::max();
    for (const auto& [dials, distance] : solutions)
        min_distance = std::min(min_distance, distance);
    return min_distance;
}

using namespace std;

long long getMinCodeEntryTime(int N, int M, vector<int> C) {
    return getMinCodeEntryTimeCpp17(N, static_cast<uint32_t>(M), C);
}


struct Args
{
    int N;
    std::vector<int> C;
};

auto tests()
{
    const auto wrapper = [](Args& p)
    {
        return getMinCodeEntryTime(p.N, static_cast<int>(p.C.size()), p.C);
    };

    std::vector<NamedTests<Args, long long>> tests = {
        {"Meta", {
                { { 3, { 1, 2, 3 } }, 2 },
                { { 10, { 9, 4, 4, 8 } }, 6 },
            }
        },
        { "extra1", {
                { { 0, {} }, 0 },
                { { 3, {} }, 0 },
                { { 10, {} }, 0 },
                { { 10, { 4 } }, 3 },
                { { 10, { 9 } }, 2 },
                { { 10, { 9, 9, 9, 9 } }, 2 },
            }
        },
        { "extra2", {
                { { 10, { 6, 2, 4, 8 } }, 10 },  // <- this is a case highlighting issue: best (1,+5), (2,+1), (2,+2), (1,-2)
                { { 10, { 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 } }, 9 },  // <- this is a case highlighting issue: best (1,+5), (2,+1), (2,+2), (1,-2)
                { { 4, { 4, 3, 2, 1, 2, 3, 4 } }, 5 },  // <- this is a case highlighting issue: best (1,+5), (2,+1), (2,+2), (1,-2)
            }
        },
    };

    return run_all_tests("l2_rotary_lock2", tests, wrapper);
}

}  // namespace l2_rotary_lock2
