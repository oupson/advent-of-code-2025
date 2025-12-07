package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:testing"
import "core:time"


get_result_07_part_01 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		// could not read file
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)


	count := 0
	it := string(data)


	beams := [dynamic]int{}
	defer delete(beams)
	for line in strings.split_lines_iterator(&it) {
		if len(beams) == 0 {
			append(&beams, strings.index_rune(line, 'S'))
		} else {
			old_beams := beams
			defer delete(old_beams)

			new_beams := [dynamic]int{}

			for b in old_beams {
				if line[b] == '^' {
					count += 1
					if (b - 1 >= 0 &&
						   (len(new_beams) == 0 || new_beams[len(new_beams) - 1] != b - 1)) {
						append(&new_beams, b - 1)
					}

					if (b + 1 < len(line)) {
						append(&new_beams, b + 1)
					}
				} else {

					if len(new_beams) == 0 || new_beams[len(new_beams) - 1] != b {
						append(&new_beams, b)
					}

				}
			}

			beams = new_beams
		}
	}

	return count, nil
}

@(test)
test_day_07_part_1 :: proc(t: ^testing.T) {
	res, err := get_result_07_part_01("inputs/07-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 21)
}

Vec2 :: struct {
	x: int,
	y: int,
}

Cell :: struct {
	is_splitter: bool,
	cache:       int,
}

get_result_07_part_02 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)

	count := 0
	it := string(data)

	grid := [dynamic][dynamic]Cell{}

	defer {
		for row in grid {
			delete(row)
		}
		delete(grid)
	}

	start := Vec2 {
		x = -1,
		y = -1,
	}

	for line in strings.split_lines_iterator(&it) {
		row := [dynamic]Cell{}
		for c, i in line {
			if c == '^' {
				append(&row, Cell{is_splitter = true, cache = -1})
			} else if c == 'S' {
				start = Vec2 {
					x = i,
					y = 0,
				}
				append(&row, Cell{is_splitter = false, cache = -1})

			} else {
				append(&row, Cell{is_splitter = false, cache = -1})
			}
		}
		append(&grid, row)
	}

	count = tachion(grid, start.x, start.y)
	return count, nil
}

tachion :: proc(grid: [dynamic][dynamic]Cell, ox, oy: int) -> int {
	if grid[oy][ox].cache != -1 {
		return grid[oy][ox].cache
	}
	count := 0
	ny := oy
	for {
		if (ny == len(grid)) {
			grid[oy][ox].cache = 1

			return 1
		}

		if grid[ny][ox].is_splitter {
			if (grid[ny][ox].cache == -1) {
				count_left := tachion(grid, ox - 1, ny)
				count_right := tachion(grid, ox + 1, ny)
				grid[ny][ox].cache = count_left + count_right
				count += count_left + count_right
			} else {
				count += grid[ny][ox].cache
			}
			break
		}

		ny += 1
	}
	grid[oy][ox].cache = count
	return count
}

@(test)
test_day_07_part_2 :: proc(t: ^testing.T) {
	res, err := get_result_07_part_02("inputs/07-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 40)
}

day07 :: proc() {
	fmt.println("=== Day 07 ===")
	res, err := get_result_07_part_01("inputs/07.txt")
	if err != nil {
		panic(fmt.tprintf("test 07 failed: %s", err))
	}
	fmt.printfln("part 01: %d", res)

	start := time.tick_now()
	res, err = get_result_07_part_02("inputs/07.txt")
	if err != nil {
		panic(fmt.tprintf("test 07 failed: %s", err))
	}
	end := time.tick_now()
	d := time.tick_diff(start, end)
	fmt.printfln("part 02: %d", res)
	fmt.println(d)
}
