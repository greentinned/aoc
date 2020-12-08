const std = @import("std");
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;

const input = @embedFile("../input.txt");

pub fn main() anyerror!void {}

pub fn solve(alloc: *Allocator, numbers: []const u8) !u32 {
    var parsed_numbers = std.ArrayList(u32).init(alloc);

    var iter = std.mem.tokenize(numbers, "\n");
    while (iter.next()) |line| {
        const num = try std.fmt.parseInt(u32, line, 10);
        try parsed_numbers.append(num);
    }

    var run = true;
    var i: usize = 0;
    var j: usize = 0;
    var k: usize = 0;
    var result: u32 = 0;
    var max = parsed_numbers.items.len;

    while (run) : ({
        i += 1;
        j += 1;
        k += 1;
    }) {
        if (i == max and j == max * 2 and k == max * 3) {
            break;
        }
    }
    return result;
}

test "solve" {
    var numbers =
        \\1721
        \\979
        \\366
        \\299
        \\675
        \\1456
    ;

    var alloc_ref = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer alloc_ref.deinit();

    const result = try solve(&alloc_ref.allocator, numbers);
    assert(result == 241861950);
}
