﻿// meta_puzzles by Sebastien Rubens
// This file is part of https://github.com/seb-pg/meta_puzzles
// Please go to https://github.com/seb-pg/meta_puzzles/README.md
// for more information
//
// To the extent possible under law, the person who associated CC0 with
// openmsg has waived all copyright and related or neighboring rights
// to openmsg.
//
// You should have received a copy of the CC0 legalcode along with this
// work.  If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

#include "test_all.h"

#include <cstdint>  // int**_t

namespace l1_uniform_integers {

static inline int32_t len_str(int64_t nb)
{
    if (nb == 0)  // not necessary due to problem definition
        return 1;
    int32_t ret = 0;
    for (; nb > 0; nb /= 10, ++ret);
    return ret;
}

static inline int64_t ones(int32_t log_value)
{
    int64_t ret = 0;
    for (int32_t i = 0; i < log_value; ++i, ret = ret * 10 + 1);
    return ret;
}

int32_t getUniformIntegerCountInIntervalCpp17(int64_t A, int64_t B)
{
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=228269118726856
    // Constraints:
    //      1 ≤ A ≤ B ≤ 10^12
    // Complexity: O(log(max(A, B)))
    //      logarithmic on the number of digits to represent the integers
    //      The python version works using integer<->string conversion, which is not great

    // Each of the following lines is O(log(max(A, B)))
    auto len_a = len_str(A);
    auto len_b = len_str(B);
    auto tmp_a = ones(len_a);
    auto tmp_b = ones(len_b);
    
    // Everything else is O(1)
    auto nb_a = (tmp_a * 10 - A) / tmp_a;
    auto nb_b = B / tmp_b;
    auto nb_m = len_b - len_a >= 2 ? 9 * (len_b - len_a - 1) : 0;
    auto nb = nb_a + nb_m + nb_b;
    if (len_a == len_b)
        nb -= 9;
    return static_cast<int32_t>(nb);  // result should always be positive
}

using namespace std;

int getUniformIntegerCountInInterval(long long A, long long B) {
    return getUniformIntegerCountInIntervalCpp17(A, B);
}


struct Args
{
    long long A;
    long long B;
};

void tests()
{
    const auto _getUniformIntegerCountInInterval = [](Args& p)
    {
        return getUniformIntegerCountInInterval(p.A, p.B);
    };

    std::vector<NamedTests<Args, int>> tests = {
        { "Meta", {
                { { 75, 300 }, 5 },
                { { 1, 9 }, 9 },
                { { 999999999999, 999999999999 }, 1 },
            }
        },
        { "extra1", {
                { { 1, 1'000'000'000'000 }, 108 },
            }
        },
        { "extra2", {
                { { 10, 99 }, 9 },
                { { 11, 98 }, 8 },
                { { 21, 89 }, 7 },
                { { 22, 88 }, 7 },
                { { 23, 87 }, 5 },
            }
        },
        { "extra3", {
                { { 11, 88 }, 8 },
                { { 11, 98 }, 8 },
                { { 11, 99 }, 9 },
            }
        },
    };

    run_list_of_tests("l1_uniform_integers", tests, _getUniformIntegerCountInInterval);
}

}  // namespace l1_uniform_integers
