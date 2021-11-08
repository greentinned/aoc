/*
 * Day 1
 * https://adventofcode.com/2015/day/1
 */

#[cfg(test)]
mod d1 {

    fn process_instr(input: &str) -> (i64, usize) {
        let mut acc: i64 = 0;
        let mut pos: usize = 0;

        let seq: Vec<char> = input.chars().collect();
        for (idx, item) in seq.iter().enumerate() {
            if pos == 0 && acc < 0 {
                pos = idx;
            }

            match item {
                '(' => acc += 1,
                ')' => acc -= 1,
                _ => (),
            }
        }

        (acc, pos)
    }

    #[test]
    fn it_processes_instructions() {
        let input1 = "(()) ()() ((( (()(()( ))((((( ()) ))( ))) )())())";
        assert_eq!(process_instr(input1).0, 0 + 3 + 3 + 3 - 1 - 1 - 3 - 3);
    }

    #[test]
    fn slove_problem_one() {
        let input = include_str!("../assets/d1.txt");
        assert_eq!(process_instr(input).0, 138);
    }

    #[test]
    fn slove_problem_two() {
        let input = include_str!("../assets/d1.txt");
        assert_eq!(process_instr(input).1, 1771);
    }
}

/*
 * Day 2
 * https://adventofcode.com/2015/day/2
 */

#[cfg(test)]
mod d2 {
    fn parse_dims(input: &str) -> Vec<u64> {
        input
            .split('x')
            .map(|val| val.parse::<u64>().expect("Failed to parse number"))
            .collect()
    }

    fn calc_wrapping(input: &str) -> u64 {
        let mut dims = parse_dims(input);
        dims.sort();

        match &dims[..] {
            &[w, h, l] => 2 * w * l + 2 * w * h + 2 * h * l + w * h,
            _ => panic!("Must have exactly 3 dims"),
        }
    }

    fn calc_ribbon(input: &str) -> u64 {
        let mut dims = parse_dims(input);
        dims.sort();

        match &dims[..] {
            &[w, h, l] => w * 2 + h * 2 + w * h * l,
            _ => panic!("Must have exactly 3 dims"),
        }
    }

    #[test]
    fn it_can_parse_dims() {
        assert_eq!(parse_dims("2x3x4"), [2, 3, 4]);
        assert_eq!(parse_dims("1x1x10"), [1, 1, 10]);
    }

    #[test]
    fn it_can_calc_area() {
        assert_eq!(calc_wrapping("2x3x4"), 58);
        assert_eq!(calc_wrapping("1x1x10"), 43);
    }

    #[test]
    fn it_can_calc_ribbon() {
        assert_eq!(calc_ribbon("2x3x4"), 34);
        assert_eq!(calc_ribbon("1x1x10"), 14);
    }

    #[test]
    fn slove_problem_one() {
        let input = include_str!("../assets/d2.txt");
        let result = input.lines().map(|val| calc_wrapping(val)).sum::<u64>();
        assert_eq!(result, 1606483);
    }

    #[test]
    fn slove_problem_two() {
        let input = include_str!("../assets/d2.txt");
        let result = input.lines().map(|val| calc_ribbon(val)).sum::<u64>();
        assert_eq!(result, 3842356);
    }
}

/*
 * Day 3
 * https://adventofcode.com/2015/day/3
 */

#[cfg(test)]
mod d3 {
    fn parse_input(input: &str) -> Vec<char> {
        input.trim().chars().collect()
    }

    fn move_by_script(input: Vec<char>) -> Vec<(i64, i64)> {
        let mut pos = (0, 0);
        let mut houses = vec![pos];

        for op in input {
            match op {
                '^' => pos = (pos.0, pos.1 + 1),
                'v' => pos = (pos.0, pos.1 - 1),
                '<' => pos = (pos.0 - 1, pos.1),
                '>' => pos = (pos.0 + 1, pos.1),
                _ => panic!("Unknown operator"),
            };
            houses.push(pos);
        }
        houses
    }

    fn count_houses(input: Vec<char>) -> usize {
        let mut moves = move_by_script(input);
        moves.sort_by(|a, b| a.partial_cmp(b).unwrap());
        moves.dedup();
        moves.len()
    }

    fn count_houses_together(input: Vec<char>) -> usize {
        let mut santa_ops: Vec<char> = Vec::new();
        let mut robot_ops: Vec<char> = Vec::new();

        input.iter().enumerate().for_each(|(i, item)| {
            if i % 2 == 0 {
                robot_ops.push(*item);
            } else {
                santa_ops.push(*item);
            }
        });

        let mut moves: Vec<(i64, i64)> = Vec::new();
        moves.extend(move_by_script(santa_ops));
        moves.extend(move_by_script(robot_ops));
        moves.sort_by(|a, b| a.partial_cmp(b).unwrap());
        moves.dedup();
        moves.len()
    }

    #[test]
    fn it_can_parse_input() {
        assert_eq!(parse_input("^>v<"), vec!['^', '>', 'v', '<']);
    }

    #[test]
    fn it_can_move_by_script() {
        assert_eq!(
            move_by_script(parse_input("^>v<")),
            vec![(0, 0), (0, 1), (1, 1), (1, 0), (0, 0)]
        );
    }

    #[test]
    fn it_can_count_houses() {
        assert_eq!(count_houses(parse_input(">")), 2);
        assert_eq!(count_houses(parse_input("^>v<")), 4);
        assert_eq!(count_houses(parse_input("^v^v^v^v^v")), 2);
    }

    #[test]
    fn it_can_count_houses_together() {
        assert_eq!(count_houses_together(parse_input("^v")), 3);
        assert_eq!(count_houses_together(parse_input("^>v<")), 3);
        assert_eq!(count_houses_together(parse_input("^v^v^v^v^v")), 11);
    }

    #[test]
    fn slove_problem_one() {
        let input = include_str!("../assets/d3.txt");
        let result = count_houses(parse_input(input));
        assert_eq!(result, 2572);
    }

    #[test]
    fn slove_problem_two() {
        let input = include_str!("../assets/d3.txt");
        let result = count_houses_together(parse_input(input));
        assert_eq!(result, 2631);
    }
}

/*
 * Day 3
 * https://adventofcode.com/2015/day/3
 */

#[cfg(test)]
mod d4 {
    use md5::{Digest, Md5};

    fn validate_hash(input: &str) -> bool {
        &input[..5] == "00000"
    }

    fn mine_hash(input: &str) -> u64 {
        let mut input_string = input.to_string();

        for i in 1..1_000_000 {
            input_string.push_str(&i.to_string());

            let mut hasher = Md5::new();
            hasher.update(input);
            let hash = hasher.finalize();
            let hash_string = String::from_utf8_lossy(&hash[..]); //.expect("Not a UTF-8 string");

            if validate_hash(&hash_string) {
                return i;
            }
        }
        0
    }

    #[test]
    fn it_can_validate_hash() {
        assert_eq!(validate_hash("000001dbbfa"), true);
        assert_eq!(validate_hash("001001dbbfa"), false);
    }

    #[test]
    fn it_can_mine_hash() {
        // assert_eq!(mine_hash("abcdef"), 609043)
        let mut input = String::from("abcdef");
        input.push_str(&(1).to_string());

        let mut hasher = Md5::new();
        hasher.update(&input);
        let hash = hasher.finalize();
        let hash_string = String::from_utf8_lossy(&hash[..]); //.expect("Not a UTF-8 string");
        assert_eq!(hash_string, "");
    }

    #[test]
    fn slove_problem_one() {
        let input = "bgvyzdsv";
        let result = 1;
        assert_eq!(result, 0);
    }

    #[test]
    fn slove_problem_two() {
        let input = "bgvyzdsv";
        let result = 1;
        assert_eq!(result, 0);
    }
}
