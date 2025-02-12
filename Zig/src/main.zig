const std = @import("std");
const add = @import("root.zig").add;

pub fn main() !void
{
    const res = add(26, 16);
    std.debug.print("Magic number is: {d}.\n", .{ res });
}
