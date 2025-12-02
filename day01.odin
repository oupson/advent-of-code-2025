package main
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"


Error :: enum {
	FailedToOpenFile,
	FailedToParseInt,
}

get_result_01_part_01 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		// could not read file
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)


	dial := 50
	count := 0
	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		d := (line[0] == 'L') ? -1 : 1
		i, e := strconv.parse_int(line[1:])
		if (!e) {
			return 0, Error.FailedToParseInt
		}

		dial = (dial + (i * d))

		for dial < 0 {
			dial += 100
		}

		for dial > 99 {

			dial -= 100
		}

		if (dial == 0) {
			count += 1
		}
	}
	return count, nil
}

@(test)
test_day_01_part_q :: proc(t: ^testing.T) {
	res, err := get_result_01_part_01("inputs/01-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 3)
}

get_result_01_part_02 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)

	dial := 50
	count := 0
	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		d := (line[0] == 'L') ? -1 : 1
		i, e := strconv.parse_int(line[1:])
		if (!e) {
			return 0, Error.FailedToParseInt
		}


		nbr := i * d

		if nbr < 0 {
			for nbr != 0 {
				dial -= 1
				if dial == 0 {
					count += 1
				} else if dial == -1 {
					dial = 99
				}
				nbr += 1
			}
		} else if nbr == 0 {
			// NOOP
		} else {
			for nbr != 0 {
				dial += 1
				if dial == 0 {
					count += 1
				} else if dial == 100 {
					dial = 0
					count += 1
				}
				nbr -= 1
			}
		}
	}
	return count, nil
}

@(test)
test_day_01_part_2 :: proc(t: ^testing.T) {
	res, err := get_result_01_part_02("inputs/01-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 6)
}

day01 :: proc() {
	fmt.println("=== Day 01 ===")
	res, err := get_result_01_part_01("inputs/01.txt")
	if err != nil {
		panic(fmt.tprintf("test 01 failed: %s", err))
	}
	fmt.printfln("part 01: %d", res)

	res, err = get_result_01_part_02("inputs/01.txt")
	if err != nil {
		panic(fmt.tprintf("test 01 failed: %s", err))
	}
	fmt.printfln("part 02: %d", res)
}
