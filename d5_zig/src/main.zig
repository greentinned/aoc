const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;
const print = std.debug.print;

const input = @embedFile("../input.txt");

pub fn getMaxId(binary_ids: []const u8) !usize {
    var caret: usize = 0;
    var caret_shift: usize = 0;
    var temp_id: [10]u8 = undefined;
    var max_id: usize = 0;

    while (caret < binary_ids.len) : (caret += 1) {
        const letter = binary_ids[caret];
        var current_bit = &temp_id[caret % (temp_id.len + caret_shift)];

        switch (letter) {
            'F', 'L' => current_bit.* = '0',
            'B', 'R' => current_bit.* = '1',
            else => {
                if (caret_shift == 0) caret_shift += 1;
                const id = try std.fmt.parseInt(usize, &temp_id, 2);
                if (id > max_id) max_id = id;
                print(
                    "\nnew_line | caret: {}, temp_id: {}, id: {}, max_id: {}, letter: {}\n",
                    .{ caret, temp_id, id, max_id, letter },
                );
            },
        }
        print(
            "cycl caret: {}, temp_id.len + caret_shift: {}, bit_idx: {}\n",
            .{ caret, temp_id.len + caret_shift, caret % (temp_id.len + caret_shift) },
        );
    }

    const id = try std.fmt.parseInt(usize, &temp_id, 2);
    if (id > max_id) max_id = id;

    return max_id;
}

test "solve part 1" {
    const code =
        \\FFFFFFFFFB
        \\FFFFFFFFBF
        \\FFFFFFFBFF
    ;
    const id = try getMaxId(code[0..]);
    testing.expect(id == 3);
}

test "solve part 2" {
    testing.expect(true);
}
