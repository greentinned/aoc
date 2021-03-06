const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const Allocator = std.mem.Allocator;

// *********** Instructions ************

const Instr = struct {
    ln: usize,
    op: []const u8,
    val: u32,
    sign: Sign,
};

const Sign = enum(u8) {
    plus = '+',
    minus = '-',
};

fn makeInstr(line: usize, opcode: []const u8, value: u32, sign: Sign) Instr {
    return Instr{
        .ln = line,
        .op = opcode,
        .val = value,
        .sign = sign,
    };
}

fn makeEmptyInstr() Instr {
    return makeInstr(0, "", 0, 0);
}

fn parseInstr(instr: []const u8, line: usize) !Instr {
    const op = instr[0..3];
    const sign = instr[4..5][0];
    const val = try std.fmt.parseInt(u32, instr[5..], 10);
    return Instr{
        .ln = line,
        .op = op,
        .val = val,
        .sign = if (sign == '+') Sign.plus else Sign.minus,
    };
}

fn containsInstr(instr: *const Instr, buf: []const Instr) bool {
    for (buf) |item, idx| {
        if (item.ln == instr.ln and std.mem.eql(u8, item.op, instr.op)) return true;
    }
    return false;
}

fn printInstr(instr: *const Instr, cursor: u32, acc: i32) void {
    print("{}: {}, {c}{} | cursor: {} | acc: {}\n", .{ instr.ln, instr.op, instr.sign, instr.val, cursor, acc });
}

// *********** Program ************

const Result = struct {
    ret: usize,
    acc: i32,
};

fn parse(alloc: *Allocator, program: []const u8) ![]Instr {
    var program_buf = std.ArrayList(Instr).init(alloc);
    var instr_index: u32 = 0;
    var iter = std.mem.tokenize(program, "\n");
    while (iter.next()) |instr| : (instr_index += 1) {
        const parsed_instr = try parseInstr(instr, instr_index);
        try program_buf.append(parsed_instr);
    }
    return program_buf.toOwnedSlice();
}

fn run(alloc: *Allocator, program: []const Instr) !Result {
    var acc: i32 = 0;
    var cursor: u32 = 0;
    var instr_buf = std.ArrayList(Instr).init(alloc);
    while (cursor < program.len) {
        const instr = program[cursor];

        if (containsInstr(&instr, instr_buf.items)) {
            return Result{ .ret = 1, .acc = acc };
        }

        try instr_buf.append(instr);
        if (std.mem.eql(u8, instr.op, "nop")) {
            cursor += 1;
        } else if (std.mem.eql(u8, instr.op, "jmp")) {
            switch (instr.sign) {
                .plus => cursor += instr.val,
                .minus => cursor -= instr.val,
            }
        } else if (std.mem.eql(u8, instr.op, "acc")) {
            switch (instr.sign) {
                .plus => acc += @intCast(i32, instr.val),
                .minus => acc -= @intCast(i32, instr.val),
            }
            cursor += 1;
        } else unreachable;
    }

    return Result{ .ret = 0, .acc = acc };
}

// *********** Testing ************

const test_input =
    \\nop +0
    \\acc +1
    \\jmp +4
    \\acc +3
    \\jmp -3
    \\acc -99
    \\acc +1
    \\jmp -4
    \\acc +6
;

const test_input2 =
    \\jmp +1
    \\jmp +0
;

const test_input3 =
    \\jmp +4
    \\nop +0
    \\acc +2
    \\nop +0
    \\acc +1
    \\jmp -1
;

const input = @embedFile("../input.txt");

test "parse instr" {
    print("\n", .{});

    const parsed_instr = try parseInstr("acc -99", 0);
    try testing.expect(parsed_instr.ln == 0);
    try testing.expectEqualStrings(parsed_instr.op, "acc");
    try testing.expect(parsed_instr.val == 99 and parsed_instr.sign == .minus);
}

test "contains instr" {
    print("\n", .{});

    const parsed_instr = try parseInstr("nop +0", 0);
    const parsed_instr2 = try parseInstr("acc -99", 5);
    const parsed_instr3 = try parseInstr("acc -99", 8);

    const buf = [_]Instr{ parsed_instr, parsed_instr3, parsed_instr2 };
    try testing.expect(containsInstr(&parsed_instr2, &buf));
    const buf2 = [_]Instr{ parsed_instr, parsed_instr3 };
    try testing.expect(!containsInstr(&parsed_instr2, &buf2));
}

test "parse program" {
    print("\n", .{});

    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();

    const result = try parse(&arena.allocator, test_input);
    try testing.expectEqualStrings(result[1].op, "acc");
    try testing.expectEqual(result.len, 9);
}

test "solve part 1" {
    print("\n", .{});

    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();

    // const program = try parse(&arena.allocator, input);
    // const program = try parse(&arena.allocator, test_input);
    // const program = try parse(&arena.allocator, test_input2);
    const program = try parse(&arena.allocator, test_input3);
    const result = try run(&arena.allocator, program);
    try testing.expectEqual(@as(i32, 1), result.acc);
    // testing.expectEqual(@as(i32, 1487), result.acc);
}

test "solve part 2" {
    print("\n", .{});

    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();

    var result: Result = undefined;
    const program = try parse(&arena.allocator, input);
    // var program = try parse(&arena.allocator, test_input);

    const options = [_][]const u8{ "nop", "jmp" };
    outer: for (options) |operator| {
        for (program) |instr, idx| {
            // MONKEY PATHCHING
            if (std.mem.eql(u8, instr.op, operator)) {
                var new_op: []const u8 = undefined;
                if (std.mem.eql(u8, operator, "jmp")) {
                    new_op = "nop";
                } else {
                    new_op = "jmp";
                }
                const prev_op = instr;
                program[idx] = makeInstr(instr.ln, new_op, instr.val, instr.sign);
                result = try run(&arena.allocator, program);
                if (result.ret == 0) {
                    // print("NORMAL RETURN WITH: {}:{}, ACC: {}\n", .{ idx, new_op, result.acc });
                    break :outer;
                } else {
                    // print("LOOP RETURN WITH: {}:{}, ACC: {}\n", .{ idx, new_op, result.acc });
                    program[idx] = prev_op;
                }
            }
        }
    }

    try testing.expectEqual(@as(i32, 1607), result.acc);
}
