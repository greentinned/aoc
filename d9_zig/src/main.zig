const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const Allocator = std.mem.Allocator;

// ******** Main ********

fn parseInput(alloc: *Allocator, raw: []const u8) ![]const i64 {
    var result = std.ArrayList(i64).init(alloc);
    var iter = std.mem.tokenize(raw, "\n");
    while (iter.next()) |item| {
        const num = try std.fmt.parseInt(i64, item, 10);
        try result.append(num);
    }

    return result.toOwnedSlice();
}

fn isSum(num: i64, buf: []const i64) bool {
    for (buf) |a| {
        for (buf) |b| {
            if (a != b and a + b == num) {
                return true;
            }
        }
    }
    return false;
}

fn getInvalidNumber(list: []const i64, preamble: u32) i64 {
    var idx: usize = preamble;
    while (idx < list.len) : (idx += 1) {
        const pre = list[idx - preamble .. idx];
        const num = list[idx];
        if (isSum(num, pre)) {
            continue;
        } else {
            return num;
        }
    }
    return -1;
}

const Result = struct {
    first: usize,
    last: usize,
};

fn findFirstLastIdx(num: i64, list: []const i64) Result {
    var first_idx: usize = 0;
    var last_idx: usize = 1;
    var checksum: i64 = list[first_idx];

    while (last_idx < list.len) {
        checksum += list[last_idx];
        if (checksum == num) {
            return .{ .first = first_idx, .last = last_idx };
        } else if (checksum > num) {
            first_idx += 1;
            last_idx = first_idx + 1;
            checksum = list[first_idx];
        } else {
            last_idx += 1;
        }
    }

    return .{ .first = 0, .last = 0 };
}

fn findMinMaxSum(list: []const i64) i64 {
    var min: i64 = list[0];
    var max: i64 = list[0];

    for (list) |num| {
        if (max < num) max = num;
        if (min > num) min = num;
    }

    return min + max;
}

// ******** Testing ********

const test_input =
    \\35
    \\20
    \\15
    \\25
    \\47
    \\40
    \\62
    \\55
    \\65
    \\95
    \\102
    \\117
    \\150
    \\182
    \\127
    \\219
    \\299
    \\277
    \\309
    \\576
;

const input = @embedFile("../input.txt");

test "parse input" {
    print("\n", .{});

    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();

    const numbers = try parseInput(&arena.allocator, test_input);
    testing.expectEqual(numbers[0], 35);
    testing.expectEqual(numbers[19], 576);
}

test "is sum" {
    print("\n", .{});

    const numbers = [_]i64{ 35, 20, 15, 25, 47 };
    testing.expect(isSum(40, &numbers));
    testing.expectEqual(isSum(70, &numbers), false);
}

test "test input" {
    print("\n", .{});

    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();

    const numbers = try parseInput(&arena.allocator, test_input);
    const number = getInvalidNumber(numbers, 5);
    testing.expectEqual(number, 127);

    const weak_idxs = findFirstLastIdx(number, numbers);
    const weak_seq = numbers[weak_idxs.first..weak_idxs.last];
    const weak_sum = findMinMaxSum(weak_seq);
    testing.expectEqual(weak_sum, 62);
}

test "solve part 1" {
    print("\n", .{});

    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();

    const numbers = try parseInput(&arena.allocator, input);
    const number = getInvalidNumber(numbers, 25);
    testing.expectEqual(number, 70639851);
}

test "solve part 2" {
    print("\n", .{});

    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();

    const numbers = try parseInput(&arena.allocator, input);
    const number = getInvalidNumber(numbers, 25);

    const weak_idxs = findFirstLastIdx(number, numbers);
    const weak_seq = numbers[weak_idxs.first..weak_idxs.last];
    const weak_sum = findMinMaxSum(weak_seq);

    testing.expectEqual(weak_sum, 8249240);
}
