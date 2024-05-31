const std = @import("std");
const intcode = @import("int_code.zig");
const List = std.ArrayList;
const splitSca = std.mem.splitScalar;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const assert = std.debug.assert;
const data = @embedFile("data/day02.txt");

pub fn main() !void {
    var item_iter = splitSca(u8, data, ',');
    var input = try std.BoundedArray(u32, 1000).init(0);
    while (item_iter.next()) |item| {
        if (item.len > 0 and item[item.len - 1] != '\n') {
            const num = try parseInt(u32, item, 10);
            try input.append(num);
        }
    }

    var partone_program = try std.BoundedArray(u32, 1000).fromSlice(input.slice());
    partone_program.set(1, 12);
    partone_program.set(2, 2);
    try intcode.run(partone_program.slice());
    print("Part  I: {d}\n", .{partone_program.get(0)});

    var solution: u32 = 0;
    outer: for (0..99) |n1| {
        for (0..99) |n2| {
            const num1: u32 = @intCast(n1);
            const num2: u32 = @intCast(n2);
            var parttwo_program = try std.BoundedArray(u32, 1000).fromSlice(input.slice());
            parttwo_program.set(1, num1);
            parttwo_program.set(2, num2);
            try intcode.run(parttwo_program.slice());
            if (parttwo_program.get(0) == 19690720) {
                solution = 100 * num1 + num2;
                break :outer;
            }
        }
    }
    print("PART II: {d}\n", .{solution});
}
