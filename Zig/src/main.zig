const std = @import("std");
const lib = @import("root.zig");

pub fn main() !void
{
    const vec = lib.vec.Vec2 {};
    std.debug.print("vec {{ .x = {d}, .y = {d} }}\n", .{ vec.x, vec.y });
}
