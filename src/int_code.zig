const std = @import("std");
const expect = std.testing.expect;
const print = std.debug.print;
const assert = std.debug.assert;
const eql = std.mem.eql;

const OpcodeError = error{
    UnknownOpcode,
};

const Opcode = enum(u32) {
    add = 1,
    multiply = 2,
    halt = 99,

    fn fromInt(num: u32) OpcodeError!Opcode {
        switch (num) {
            1 => return Opcode.add,
            2 => return Opcode.multiply,
            99 => return Opcode.halt,
            // not a known opcode
            else => {
                print("unknown code: {d}\n", .{num});
                return OpcodeError.UnknownOpcode;
            },
        }
    }
};

fn print_program(program: []u32) void {
    print("[", .{});
    for (program, 0..) |val, i| {
        if (i == (program.len - 1)) {
            print("{d}", .{val});
        } else {
            print("{d} ", .{val});
        }
    }
    print("]\n", .{});
}

fn get_val(program: []u32, pos: usize) u32 {
    return program[pos];
}

pub fn step(program: []u32, start: usize) !usize {
    const op_pos = start;
    const op_code = try Opcode.fromInt(get_val(program, start));
    switch (op_code) {
        Opcode.add => {
            const pos_a = program[op_pos + 1];
            const pos_b = program[op_pos + 2];
            const pos_c = program[op_pos + 3];
            program[pos_c] = program[pos_a] + program[pos_b];
            return op_pos + 4;
        },
        Opcode.multiply => {
            const pos_a = program[op_pos + 1];
            const pos_b = program[op_pos + 2];
            const pos_c = program[op_pos + 3];
            program[pos_c] = program[pos_a] * program[pos_b];
            return op_pos + 4;
        },
        Opcode.halt => {
            unreachable;
        },
    }
}

pub fn run(program: []u32) !void {
    var next_pos: usize = 0;
    var next_op: Opcode = try Opcode.fromInt(program[next_pos]);
    while (next_op != Opcode.halt) {
        next_pos = try step(program, next_pos);
        next_op = try Opcode.fromInt(program[next_pos]);
    }
}

test "can do simple addition" {
    var program = [_]u32{ 1, 3, 1, 3, 99 };
    try run(&program);
    try expect(program[3] == 6);
}

test "can do simple multiply" {
    var program = [_]u32{ 2, 3, 1, 3, 99 };
    try run(&program);
    try expect(program[3] == 9);
}

test "part I example I" {
    var program = [_]u32{ 1, 0, 0, 0, 99 };
    try run(&program);
    try expect(eql(u32, &program, &[_]u32{ 2, 0, 0, 0, 99 }));
}

test "part I example II" {
    var program = [_]u32{ 2, 3, 0, 3, 99 };
    try run(&program);
    try expect(eql(u32, &program, &[_]u32{ 2, 3, 0, 6, 99 }));
}

test "part I example III" {
    var program = [_]u32{ 2, 4, 4, 5, 99, 0 };
    try run(&program);
    try expect(eql(u32, &program, &[_]u32{ 2, 4, 4, 5, 99, 9801 }));
}

test "part I example IIII" {
    var program = [_]u32{ 1, 1, 1, 4, 99, 5, 6, 0, 99 };
    try run(&program);
    try expect(eql(u32, &program, &[_]u32{ 30, 1, 1, 4, 2, 5, 6, 0, 99 }));
}
