
package main
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"


int_size :: proc(i: int) -> int {
	p := 10
	s := 1
	for p < i {
		s += 1
		p = p * 10
	}
	return s
}

@(test)
test_int_size :: proc(t: ^testing.T) {
	testing.expect(t, int_size(100) == 2)
	testing.expect(t, int_size(9999) == 4)
}

pow_int :: proc(x, y: int) -> (z: int) {
	z = 1
	for _ in 0 ..< y {
		z *= x
	}
	return
}

@(test)
test_pow :: proc(t: ^testing.T) {
	testing.expect(t, pow_int(10, 1) == 10)
}

get_result_02_part_01 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		// could not read file
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)


	count := 0
	it := string(data)

	l, _ := strings.split_lines_iterator(&it)

	for p in strings.split_iterator(&l, ",") {
		rs, _ := strings.split(p, "-")
		defer delete(rs)

		start, ok := strconv.parse_int(rs[0])

		if !ok {
			return 0, Error.FailedToParseInt
		}
		end, ok2 := strconv.parse_int(rs[1])
		if !ok2 {
			return 0, Error.FailedToParseInt
		}


		for i in start ..= end {
			s := int_size(i)

			m := pow_int(10, s / 2)

			left := i / (m)
			right := i - (left * m)

			if left == right {
				count += i
			}
		}
	}

	return count, nil
}

@(test)
test_day02_part_1 :: proc(t: ^testing.T) {
	res, err := get_result_02_part_01("inputs/02-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, 1227775554, res)
}

is_invalid_02 :: proc(id: int) -> bool {
	s := int_size(id)

	a: for i in 1 ..= s / 2 {
		if s % i != 0 {
			continue
		}
		m := pow_int(10, i)
		rest := id / m
		prev := id - (rest * m)

		for rest > 0 {
			tmp_rest := rest / m
			tmp_prev := rest - (tmp_rest * m)

			if (tmp_prev != prev) {
				continue a
			}
			rest = tmp_rest
			prev = tmp_prev
		}
		return true
	}

	return false
}

@(test)
test_is_invalid_02 :: proc(t: ^testing.T) {
	testing.expect(t, is_invalid_02(11))
	testing.expect(t, !is_invalid_02(12))
	testing.expect(t, is_invalid_02(22))
	testing.expect(t, is_invalid_02(999))
	testing.expect(t, is_invalid_02(824824824))
}

get_result_02_part_02 :: proc(filename: string) -> (int, Error) {
	data, ok := os.read_entire_file(filename, context.allocator)
	if !ok {
		return 0, Error.FailedToOpenFile
	}
	defer delete(data, context.allocator)

	count := 0
	it := string(data)

	l, _ := strings.split_lines_iterator(&it)

	for p in strings.split_iterator(&l, ",") {
		rs, _ := strings.split(p, "-")
		defer delete(rs)

		start, ok := strconv.parse_int(rs[0])

		if !ok {
			return 0, Error.FailedToParseInt
		}
		end, ok2 := strconv.parse_int(rs[1])
		if !ok2 {
			return 0, Error.FailedToParseInt
		}

		for i in start ..= end {
			if (is_invalid_02(i)) {
				count += i
			}
		}
	}

	return count, nil
}

@(test)
test_day_02_part_2 :: proc(t: ^testing.T) {
	res, err := get_result_02_part_02("inputs/02-test01.txt")
	testing.expect_value(t, err, nil)
	testing.expect_value(t, 4174379265, res)
}

day02 :: proc() {
	fmt.println("=== Day 02 ===")
	res, err := get_result_02_part_01("inputs/02.txt")
	if err != nil {
		panic(fmt.tprintf("test 02 failed: %s", err))
	}
	fmt.printfln("part 01: %d", res)

	res, err = get_result_02_part_02("inputs/02.txt")
	if err != nil {
		panic(fmt.tprintf("test 02 failed: %s", err))
	}
	fmt.printfln("part 02: %d", res)
}
