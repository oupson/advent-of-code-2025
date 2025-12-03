
package main
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"


get_result_03_part_01 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		// could not read file
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)


	count := 0
	it := string(data)

	for line in strings.split_lines_iterator(&it) {
		nbr := make([]int, len(line))
		defer delete(nbr)

		for c, i in line {
			d, ok := strconv.digit_to_int(c)
			if !ok {
				return 0, Error.FailedToParseInt
			}

			nbr[i] = d
		}

		l_max := nbr[0]
		r_max := nbr[1]

		i := 1
		for i < len(nbr) {
			if nbr[i] > l_max && i < len(nbr) - 1 {
				l_max = nbr[i]
				r_max = nbr[i + 1]
			} else if nbr[i] > r_max {
				r_max = nbr[i]
			}

			i += 1
		}

		count += (l_max * 10) + r_max
	}


	return count, nil
}

@(test)
test_day_03_part_1 :: proc(t: ^testing.T) {
	res, err := get_result_03_part_01("inputs/03-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 357)
}


get_result_03_part_02 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)

	count := 0


	return count, nil
}

@(test)
test_day_03_part_2 :: proc(t: ^testing.T) {
	res, err := get_result_03_part_02("inputs/03-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 3121910778619)
}

day03 :: proc() {
	fmt.println("=== Day 03 ===")
	res, err := get_result_03_part_01("inputs/03.txt")
	if err != nil {
		panic(fmt.tprintf("test 03 failed: %s", err))
	}
	fmt.printfln("part 01: %d", res)

	res, err = get_result_03_part_02("inputs/03.txt")
	if err != nil {
		panic(fmt.tprintf("test 03 failed: %s", err))
	}
	fmt.printfln("part 02: %d", res)
}
