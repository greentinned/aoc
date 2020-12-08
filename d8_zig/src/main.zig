const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const Allocator = std.mem.Allocator;

// *********** Instructions ************

const Instr = struct {
    ln: usize,
    op: []const u8,
    val: u32,
    sign: u8,
};

fn makeInstr(line: usize, opcode: []const u8, value: u32, sign: u8) Instr {
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
    return Instr{ .ln = line, .op = op, .val = val, .sign = sign };
}

fn containsInstr(instr: *const Instr, buf: []const Instr) bool {
    for (buf) |item, idx| {
        // print("containsInstr: {} == {}, {} == {}\n", .{ item.ln, instr.ln, item.op, instr.op });
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
    print("\n", .{});

    var acc: i32 = 0;
    var cursor: u32 = 0;
    // var instr_buf_len: u32 = 0;
    var instr_buf = std.ArrayList(Instr).init(alloc);
    // while (cursor < program.len) : (instr_buf_len += 1) {
    while (cursor < program.len) {
        const instr = program[cursor];

        if (containsInstr(&instr, instr_buf.items)) {
            return Result{ .ret = 1, .acc = acc };
        }

        try instr_buf.append(instr);
        if (std.mem.eql(u8, instr.op, "nop")) {
            cursor += 1;
        } else if (std.mem.eql(u8, instr.op, "jmp")) {
            if (instr.sign == '-') {
                cursor -= instr.val;
            } else {
                cursor += instr.val;
            }
        } else if (std.mem.eql(u8, instr.op, "acc")) {
            if (instr.sign == '-') {
                acc -= @intCast(i32, instr.val);
            } else {
                acc += @intCast(i32, instr.val);
            }
            cursor += 1;
        } else unreachable;

        printInstr(&instr, cursor, acc);
    }

    // unreachable;

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

const input = @embedFile("../input.txt");

test "parse instr" {
    const parsed_instr = try parseInstr("acc -99", 0);
    testing.expect(parsed_instr.ln == 0);
    testing.expectEqualStrings(parsed_instr.op, "acc");
    testing.expect(parsed_instr.val == 99 and parsed_instr.sign == '-');
}

test "contains instr" {
    const parsed_instr = try parseInstr("nop +0", 0);
    const parsed_instr2 = try parseInstr("acc -99", 5);
    const parsed_instr3 = try parseInstr("acc -99", 8);

    const buf = [_]Instr{ parsed_instr, parsed_instr3, parsed_instr2 };
    testing.expect(containsInstr(&parsed_instr2, &buf));
    const buf2 = [_]Instr{ parsed_instr, parsed_instr3 };
    testing.expect(!containsInstr(&parsed_instr2, &buf2));
}

test "parse program" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();

    const result = try parse(&arena.allocator, test_input);
    testing.expectEqualStrings(result[1].op, "acc");
    testing.expectEqual(result.len, 9);
}

test "solve part 1" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();

    const program = try parse(&arena.allocator, input);
    // const program = try parse(&arena.allocator, test_input);
    const result = try run(&arena.allocator, program);
    testing.expectEqual(@as(i32, 1487), result.acc);
}

test "solve part 2" {
    var arena = std.heap.ArenaAllocator.init(testing.allocator);
    defer arena.deinit();

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
                // Can not assign to constant
                program[idx] = makeInstr(instr.ln, new_op, instr.val, instr.sign);
                const result = try run(&arena.allocator, program);
                if (result.ret == 0) {
                    print("NORMAL RETURN WITH: {}:{}, ACC: {}", .{ idx, new_op, result.acc });
                    break :outer;
                } else {
                    print("LOOP RETURN WITH: {}:{}, ACC: {}", .{ idx, new_op, result.acc });
                    program[idx] = prev_op;
                }
            }
        }
    }

    // const result = try run(&arena.allocator, program);
    // testing.expectEqual(@as(i32, 1487), result);
}
