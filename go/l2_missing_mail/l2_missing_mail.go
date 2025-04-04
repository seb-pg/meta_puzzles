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

package l2_missing_mail

import (
	"math"
	"meta_puzzles/std"
	"meta_puzzles/test"
)

/*
// Add these to make it work on Meta's website (and remove std. in the code below)

func Accumulate(elements []int32, init float64) R {
	// similar to C++ std::accumulate
	for _, elt := range elements {
		init += float64(elt)
	}
	return init
}

type predicate_t func(x Result, y Result) bool

func MaxMinElement(elements []Result, pred predicate_t) *Result {
	// For anything
	last_pos := 0
	last_elt := &elements[0]
	for pos, elt := range elements[1:] {
		if pred(elt, *last_elt) {
			last_pos = pos + 1
			last_elt = &elements[last_pos]
		}
	}
	return &elements[last_pos]
}
*/

type Result struct {
	mail_room_value float64
	total_value     float64
}

func (r Result) both() float64 {
	return r.mail_room_value + r.total_value
}

func getMaxExpectedProfit(N int32, V []int32, C int32, S float64) float64 {
    // https://www.metacareers.com/profile/coding_puzzles/?puzzle=401886137594615
    // Constraints:
    //      1   ≤ N  ≤ 4,000    N is the number of parcels
    //      0   ≤ Vi ≤ 1,000    Vi is the value of a parcel
    //      1   ≤ C  ≤ 1,000    C is the cost the enter a room
    //      0.0 ≤ S   ≤ 1.0     S is the probability the content of the mailroom is stolen
    // Complexity: O(N^2)

	if S == 0 {
		return std.Accumulate(V, 0.0) - float64(C)
	}

	// Initial result
	results := make([]Result, 0, len(V))
	results = append(results, Result{0, 0})
	for _, Vi := range V {
		// Update the best results for the new day, considering the packages could've stolen in previous round
		for idx, _ := range results {
			results[idx].mail_room_value *= (1 - S)
		}

		// Possibility #1 : pick up packages on this day
		// We need to add the best(max) possible total_value among all saved so far
		max_fn1 := func(a Result, b Result) bool { return a.both() > b.both() }
		pickup_value := float64(Vi-C) + std.MaxMinElement(results, max_fn1).both()

		// Possibility #2 : do not pick up packages on this day
		for idx, _ := range results {
			results[idx].mail_room_value += float64(Vi)
		}

		results = append(results, Result{0, pickup_value})
	}

	max_fn2 := func(a Result, b Result) bool { return a.total_value > b.total_value }
	return std.MaxMinElement(results, max_fn2).total_value
}

type Args struct {
	V   []int32
	C   int32
	S   float64
	res float64
}

func (self Args) GetResult() any {
	return self.res
}

func Tests() uint {
	wrapper := func(p Args) float64 { return getMaxExpectedProfit(int32(len(p.V)), p.V, p.C, p.S) }

	args_lists := []Args{
		{[]int32{10, 2, 8, 6, 4}, 5, 0.0, 25.0},
		{[]int32{10, 2, 8, 6, 4}, 5, 1.0, 9.0},
		{[]int32{10, 2, 8, 6, 4}, 3, 0.5, 17.0},
		{[]int32{10, 2, 8, 6, 4}, 3, 0.15, 20.10825},
	}

	pred := func(lhs float64, rhs float64) bool { return math.Abs(lhs-rhs) < 0.000_001 }
	return test.RunAllTests("l2_missing_mail", args_lists, wrapper, pred)
}
