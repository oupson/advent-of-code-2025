
package main
import "core:crypto/_fiat/field_curve25519"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"


get_result_05_part_01 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		// could not read file
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)


	count := 0
	it := string(data)

	ranges := [dynamic][2]int{}
	defer delete(ranges)

	for line in strings.split_lines_iterator(&it) {
		if line == "" {
			break
		}

		sep_index := strings.index_rune(line, '-')

		first, ok := strconv.parse_int(line[0:sep_index])
		if !ok {
			return 0, Error.FailedToParseInt
		}

		second, ok2 := strconv.parse_int(line[sep_index + 1:])
		if !ok2 {
			return 0, Error.FailedToParseInt
		}

		append(&ranges, [2]int{first, second})
	}

	for line in strings.split_lines_iterator(&it) {
		nbr, ok := strconv.parse_int(line)
		if !ok {
			return 0, Error.FailedToParseInt
		}

		for range in ranges {
			if range[0] <= nbr && range[1] >= nbr {
				count += 1
				break
			}
		}
	}

	return count, nil
}

@(test)
test_day_05_part_1 :: proc(t: ^testing.T) {
	res, err := get_result_05_part_01("inputs/05-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 3)
}


get_result_05_part_02 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)

	count := 0
	it := string(data)


	ranges := [dynamic][2]int{}
	defer delete(ranges)

	lines := 0

	for line in strings.split_lines_iterator(&it) {
		if line == "" {
			break
		}

		sep_index := strings.index_rune(line, '-')

		first, ok := strconv.parse_int(line[0:sep_index])
		if !ok {
			return 0, Error.FailedToParseInt
		}

		second, ok2 := strconv.parse_int(line[sep_index + 1:])
		if !ok2 {
			return 0, Error.FailedToParseInt
		}

		stack_ranges := [dynamic][2]int{}
		append(&stack_ranges, [2]int{first, second})

		a: for len(stack_ranges) > 0 {
			r := pop(&stack_ranges)

			for existing_range in ranges {
				// If in another range
				if (existing_range[0] <= r[0] && existing_range[1] >= r[1]) {
					continue a
				}
				// If another range in it
				if (existing_range[0] > r[0] && existing_range[1] < r[1]) {
					// Left
					append(&stack_ranges, [2]int{r[0], existing_range[0] - 1})
					// Right
					append(&stack_ranges, [2]int{existing_range[1] + 1, r[1]})
					continue a
				}
				// Range on the left
				if existing_range[0] <= r[0] && existing_range[1] >= r[0] {
					append(&stack_ranges, [2]int{existing_range[1] + 1, r[1]})
					continue a
				}

				// Range on the right
				if (existing_range[0] <= r[1] && existing_range[1] >= r[1]) {
					append(&stack_ranges, [2]int{r[0], existing_range[0] - 1})
					continue a
				}
			}

			append(&ranges, r)
			count = count + (r[1] - r[0] + 1)
		}
	}


	return count, nil
}

@(test)
test_day_05_part_2 :: proc(t: ^testing.T) {
	res, err := get_result_05_part_02("inputs/05-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 14)
}

day05 :: proc() {
	fmt.println("=== Day 05 ===")
	res, err := get_result_05_part_01("inputs/05.txt")
	if err != nil {
		panic(fmt.tprintf("test 05 failed: %s", err))
	}
	fmt.printfln("part 01: %d", res)

	res, err = get_result_05_part_02("inputs/05.txt")
	if err != nil {
		panic(fmt.tprintf("test 05 failed: %s", err))
	}
	fmt.printfln("part 02: %d", res)
}
