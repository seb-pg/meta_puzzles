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

package l1_director_photography1

import (
	"meta_puzzles/test"
)

type Counts struct {
	p int
	b int
}

func _getArtisticPhotographCount[T int64 | int](N int, C string, X int, Y int) T {
	w := Y + 1
	count := Counts{0, 0}
	counts := make([]Counts, 0, len(C)+w*2)
	for i := 0; i < w; i += 1 { // add space at the beginning to avoid special treatment of indices later
		counts = append(counts, Counts{0, 0})
	}
	for _, ci := range C {
		if ci == 'P' {
			count.p += 1
		} else if ci == 'B' {
			count.b += 1
		}
		counts = append(counts, count)
	}
	last := counts[len(counts)-1]
	for i := 0; i < w; i += 1 { // add space at the end to avoid special treatment of indices later
		counts = append(counts, last)
	}

	// To make things more readable, we are finding first the point where 'A' is found: O(N)
	possible := make([]int, 0, len(C))
	j := w
	for _, ci := range C {
		if ci == 'A' {
			possible = append(possible, j)
		}
		j += 1
	}

	// Count PABs : O(N)
	X1 := X - 1
	Y1 := Y + 1
	nb := T(0)
	for _, i := range possible {
		nb += T(counts[i-X].p-counts[i-Y1].p) * T(counts[i+Y].b-counts[i+X1].b)
	}

	// Count BAPs : O(N)
	for _, i := range possible {
		nb += T(counts[i-X].b-counts[i-Y1].b) * T(counts[i+Y].p-counts[i+X1].p)
	}

	return nb // result should always be positive
}

func getArtisticPhotographCount(N int, C string, X int, Y int) int {
	return int(_getArtisticPhotographCount[int](N, C, X, Y))
}

type Args struct {
	C   string
	X   int
	Y   int
	res int
}

func (self Args) GetResult() any {
	return self.res
}

func Tests() uint {
	wrapper := func(p Args) int { return getArtisticPhotographCount(len(p.C), p.C, p.X, p.Y) }

	args_lists := []Args{
		{"APABA", 1, 2, 1},
		{"APABA", 2, 3, 0},
		{".PBAAP.B", 1, 3, 3},
	}

	return test.RunAllTests("l1_director_photography1", args_lists, wrapper)
}
