
package main
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


	return count, nil
}

@(test)
test_day_05_part_2 :: proc(t: ^testing.T) {
	res, err := get_result_05_part_02("inputs/05-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 43)
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
