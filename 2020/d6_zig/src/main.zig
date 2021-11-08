const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;

const input = @embedFile("../input.txt");

fn parseInput(alloc: *Allocator, in: []const u8) ![]const []const u8 {
    var result = std.ArrayList([]const u8).init(alloc);

    var iter = std.mem.split(in, "\n\n");
    while (iter.next()) |line| {
        var j_result = std.ArrayList([]const u8).init(alloc);
        var j_iter = std.mem.split(line, "\n");
        while (j_iter.next()) |item| {
            try j_result.append(item);
        }
        const j_line = try std.mem.join(alloc, "", j_result.toOwnedSlice());
        try result.append(j_line);
    }

    return result.toOwnedSlice();
}

// ********** Testing **********

const test_input =
    \\abc
    \\
    \\a
    \\b
    \\c
    \\
    \\ab
    \\ac
    \\
    \\a
    \\a
    \\a
    \\a
    \\
    \\b
;

test "parsing input" {
    var alloc_ref = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer alloc_ref.deinit();

    const res = try parseInput(&alloc_ref.allocator, test_input);

    testing.expectEqualStrings("abc", res[0]);
    testing.expectEqualStrings("abc", res[1]);
    testing.expectEqualStrings("abac", res[2]);
    testing.expectEqualStrings("aaaa", res[3]);
    testing.expectEqualStrings("b", res[4]);
}
