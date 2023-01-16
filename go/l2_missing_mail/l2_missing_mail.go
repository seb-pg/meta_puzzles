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
	"meta_puzzles/std"
	"meta_puzzles/test"
)

type Result struct {
	mail_room_value float64
	total_value     float64
}

func (r Result) both() float64 {
	return r.mail_room_value + r.total_value
}

// <TODO replace the following>

type Predicate[T Result] func(x, y T) bool

func MinMaxElementPred[T Result](elements []T, pred Predicate[T]) *T {
	// similar to C++ std::max_element
	min_pos := 0
	for pos, elt := range elements {
		if pos == 0 {
			continue
		}
		if pred(elt, elements[min_pos]) {
			min_pos = pos
		}
	}
	return &elements[min_pos]
}

// </TODO replace the following>

func getMaxExpectedProfit(N int, V []int, C int, S float64) float64 {
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
		max_fn1 := func(e1 Result, e2 Result) bool { return e1.both() > e2.both() }
		pickup_value := float64(Vi-C) + MinMaxElementPred(results, max_fn1).both() // TODO: <-- replace this

		// Possibility #2 : do not pick up packages on this day
		for idx, _ := range results {
			results[idx].mail_room_value += float64(Vi)
		}

		results = append(results, Result{0, pickup_value})
	}

	max_fn2 := func(e1 Result, e2 Result) bool { return e1.total_value > e2.total_value }
	return MinMaxElementPred(results, max_fn2).total_value
}

type Args struct {
	V   []int
	C   int
	S   float64
	res float64
}

func (self Args) GetResult() any {
	return self.res
}

func Tests() uint {
	wrapper := func(p Args) float64 { return getMaxExpectedProfit(len(p.V), p.V, p.C, p.S) }

	args_lists := []Args{
		{[]int{10, 2, 8, 6, 4}, 5, 0.0, 25.0},
		{[]int{10, 2, 8, 6, 4}, 5, 1.0, 9.0},
		{[]int{10, 2, 8, 6, 4}, 3, 0.5, 17.0},
		{[]int{10, 2, 8, 6, 4}, 3, 0.15, 25.0},
	}

	return test.RunAllTests("l2_missing_mail", args_lists, wrapper)
}
