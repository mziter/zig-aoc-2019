const std = @import("std");
const data = @embedFile("data/day01.txt");
const splitSca = std.mem.splitScalar;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const expect = std.testing.expect;

pub fn main() !void {
    var line_iter = splitSca(u8, data, '\n');
    var sum: u32 = 0;
    while (line_iter.next()) |line| {
        if (line.len > 0) {
            const num = try parseInt(u32, line, 10);
            sum += required_fuel(num);
        }
    }
    print("PartI  : {d}\n", .{sum});

    sum = 0;
    line_iter.reset();
    while (line_iter.next()) |line| {
        if (line.len > 0) {
            const num = try parseInt(u32, line, 10);
            sum += total_required_fuel(num);
        }
    }
    print("PartII : {d}\n", .{sum});
}

fn total_required_fuel(mass: u32) u32 {
    var total: u32 = 0;
    var last_mass: u32 = mass;
    while (last_mass > 0) {
        const fuel = required_fuel(last_mass);
        total += fuel;
        last_mass = fuel;
    }
    return total;
}

fn required_fuel(mass: u32) u32 {
    const div = mass / 3;
    if (div < 2) return 0 else return div - 2;
}

test "required fuel is correct" {
    try expect(required_fuel(12) == 2);
    try expect(required_fuel(14) == 2);
    try expect(required_fuel(1969) == 654);
    try expect(required_fuel(100756) == 33583);
}

test "required total fuel is correct" {
    try expect(total_required_fuel(12) == 2);
    try expect(total_required_fuel(14) == 2);
    try expect(total_required_fuel(1969) == 966);
    try expect(total_required_fuel(100756) == 50346);
}
