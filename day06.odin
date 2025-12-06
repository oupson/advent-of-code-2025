
package main
import "core:crypto/_fiat/field_curve25519"
import "core:fmt"
import "core:log"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"


get_result_06_part_01 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		// could not read file
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)


	count := 0
	it := string(data)

	nbr := [dynamic][dynamic]int{}
	defer {
		for n in nbr {
			delete(n)
		}
		delete(nbr)
	}

	for line in strings.split_lines_iterator(&it) {
		eps := strings.split(line, " ")
		defer delete(eps)
		n_line := [dynamic]int{}

		i := 0
		for ep in eps {
			if ep == "" do continue

			n, ok := strconv.parse_int(ep)
			if ok {
				append(&n_line, n)
			} else {
				colunm := nbr[0][i]
				if ep == "+" {
					for y in 1 ..< len(nbr) {
						colunm += nbr[y][i]
					}
				} else if ep == "*" {
					for y in 1 ..< len(nbr) {
						colunm *= nbr[y][i]
					}
				} else {
					return i, Error.FailedToParseInt
				}
				count += colunm
			}
			i += 1
		}
		append(&nbr, n_line)
	}

	return count, nil
}

@(test)
test_day_06_part_1 :: proc(t: ^testing.T) {
	res, err := get_result_06_part_01("inputs/06-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 4277556)
}


get_result_06_part_02 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)

	count := 0
	it := string(data)

	nbr := [dynamic][dynamic]int{}
	defer {
		for n in nbr {
			delete(n)
		}
		delete(nbr)
	}


	for line in strings.split_lines_iterator(&it) {
		n_line := [dynamic]int{}

		if len(it) > 0 {
			for ep in line {
				if ep == ' ' {
					append(&n_line, -1)
				} else {
					append(&n_line, int(ep - '0'))
				}
			}
			append(&nbr, n_line)
		} else {
			i := 0
			for i < len(line) {
				end_index := i + 1
				for end_index < len(line) {
					if (line[end_index] != ' ') {
						end_index = end_index - 1
						break
					} else {
						end_index += 1
					}
				}


				total := 0
				if line[i] == '+' {
					for col_index in i ..< end_index {
						col := 0
						for y in 0 ..< len(nbr) {
							if nbr[y][col_index] == -1 {
								continue
							}
							col = col * 10 + nbr[y][col_index]
						}
						total += col
					}
				} else {
					for col_index in i ..< end_index {
						col := 0
						for y in 0 ..< len(nbr) {
							if nbr[y][col_index] == -1 {
								continue
							}
							col = col * 10 + nbr[y][col_index]
						}
						if total == 0 {
							total = col
						} else {
							total = total * col
						}
					}
				}
				count += total
				i = end_index + 1
			}
		}
	}

	return count, nil
}

@(test)
test_day_06_part_2 :: proc(t: ^testing.T) {
	res, err := get_result_06_part_02("inputs/06-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, res, 3263827)
}

day06 :: proc() {
	fmt.println("=== Day 06 ===")
	res, err := get_result_06_part_01("inputs/06.txt")
	if err != nil {
		panic(fmt.tprintf("test 06 failed: %s", err))
	}
	fmt.printfln("part 01: %d", res)

	res, err = get_result_06_part_02("inputs/06.txt")
	if err != nil {
		panic(fmt.tprintf("test 06 failed: %s", err))
	}
	fmt.printfln("part 02: %d", res)
}
