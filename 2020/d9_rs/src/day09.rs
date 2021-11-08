/*
Day 9
*/

#[allow(dead_code)]
fn parse_input(string: &str) -> Vec<i64> {
    string
        .lines()
        .map(|line| line.parse::<i64>().unwrap())
        .collect()
}

#[allow(dead_code)]
fn is_sum(num: i64, seq: &[i64]) -> bool {
    for a in seq {
        for b in seq {
            if a != b && a + b == num {
                return true;
            }
        }
    }
    false
}

#[allow(dead_code)]
fn get_invalid_number(seq: &Vec<i64>, preamble: usize) -> i64 {
    for (idx, num) in seq[preamble..].iter().enumerate() {
        let (_, pre) = seq[idx..(idx + preamble)].split_at(0);
        if is_sum(*num, pre) {
            continue;
        } else {
            return *num;
        }
    }
    -1
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_input() {
        let input = include_str!("../assets/day09_test.txt");
        let test_input = parse_input(input);
        assert_eq!(test_input[0], 35);
    }

    #[test]
    fn test_is_sum() {
        let numbers = vec![35, 20, 15, 25, 47];
        assert_eq!(is_sum(40, &numbers), true);
        assert_eq!(is_sum(70, &numbers), false);
    }

    #[test]
    fn test_get_invalid_number() {
        let input = include_str!("../assets/day09_test.txt");
        let numbers = parse_input(input);
        let number = get_invalid_number(&numbers, 5);
        assert_eq!(number, 127);
    }

    #[test]
    fn solve_part_one() {
        let input = include_str!("../assets/day09.txt");
        let test_input = parse_input(input);
        let result = get_invalid_number(&test_input, 25);
        assert_eq!(result, 70639851);
    }

    #[test]
    fn solve_part_two() {
        let input = include_str!("../assets/day09.txt");
        let test_input = parse_input(input);
        let result = get_invalid_number(&test_input, 25);
        assert_eq!(result, 8249240);
    }
}
