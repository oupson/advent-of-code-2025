
package main
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"


get_result_04_part_01 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		// could not read file
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)


	count := 0
	it := string(data)


	grid := make([dynamic][]bool, 0)
	defer {
		for g in grid {
			delete(g)
		}
		delete(grid)
	}
	for line in strings.split_lines_iterator(&it) {
		grid_line := make([]bool, len(line))

		for c, i in line {
			grid_line[i] = c == '@'
		}

		append(&grid, grid_line)
	}

	for y in 0 ..< len(grid) {
		line := grid[y]
		for x in 0 ..< len(line) {
			if !line[x] {continue}

			count_env := -1
			for y1 in max(y - 1, 0) ..= min(y + 1, len(grid) - 1) {
				for x1 in max(x - 1, 0) ..= min(x + 1, len(line) - 1) {
					if grid[y1][x1] {
						count_env += 1
					}
				}
			}


			if count_env < 4 {
				count += 1
			}
		}
	}

	return count, nil
}

@(test)
test_day_04_part_1 :: proc(t: ^testing.T) {
	res, err := get_result_04_part_01("inputs/04-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 13)
}


get_result_04_part_02 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)

	count := 0
	it := string(data)
	grid := make([dynamic][]bool, 0)
	defer {
		for g in grid {
			delete(g)
		}
		delete(grid)
	}
	for line in strings.split_lines_iterator(&it) {
		grid_line := make([]bool, len(line))

		for c, i in line {
			grid_line[i] = c == '@'
		}

		append(&grid, grid_line)
	}

	for {
		round := 0
		for y in 0 ..< len(grid) {
			line := grid[y]
			for x in 0 ..< len(line) {
				if !line[x] {continue}

				count_env := -1
				for y1 in max(y - 1, 0) ..= min(y + 1, len(grid) - 1) {
					for x1 in max(x - 1, 0) ..= min(x + 1, len(line) - 1) {
						if grid[y1][x1] {
							count_env += 1
						}
					}
				}

				if count_env < 4 {
					grid[y][x] = false
					round += 1
				}
			}
		}

		if round == 0 {
			break
		}
		count += round
	}

	return count, nil
}

@(test)
test_day_04_part_2 :: proc(t: ^testing.T) {
	res, err := get_result_04_part_02("inputs/04-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 43)
}

day04 :: proc() {
	fmt.println("=== Day 04 ===")
	res, err := get_result_04_part_01("inputs/04.txt")
	if err != nil {
		panic(fmt.tprintf("test 04 failed: %s", err))
	}
	fmt.printfln("part 01: %d", res)

	res, err = get_result_04_part_02("inputs/04.txt")
	if err != nil {
		panic(fmt.tprintf("test 04 failed: %s", err))
	}
	fmt.printfln("part 02: %d", res)
}
