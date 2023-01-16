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

package l1_rotary_lock1

import "meta_puzzles/test"

func min(a int, b int) int {
	if a < b {
		return a
	}
	return b
}

func getMinCodeEntryTime(N int, M int, C []int) int64 {
	pos := int(1)
	nb := int64(0)
	for _, target := range C {
		positive_move := (target - pos) % N // positive move
		if positive_move < 0 {
			positive_move += N
		}
		negative_move := N - positive_move
		nb += int64(min(positive_move, negative_move))
		pos = target
	}
	return nb
}

type Args struct {
	N   int
	C   []int
	res int64
}

func (self Args) GetResult() any {
	return self.res
}

func Tests() uint {
	wrapper := func(p Args) int64 { return getMinCodeEntryTime(p.N, len(p.C), p.C) }

	args_lists := []Args{
		{3, []int{1, 2, 3}, 2},
		{10, []int{9, 4, 4, 8}, 11},
	}

	return test.RunAllTests("l1_rotary_lock1", args_lists, wrapper)
}
