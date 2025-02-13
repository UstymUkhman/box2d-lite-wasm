const std = @import("std");
const Vec2 = @import("root.zig").Vec2;

pub fn main() !void
{
    const vec = Vec2 {};
    std.debug.print("vec {{ .x = {d}, .y = {d} }}\n", .{ vec.x, vec.y });
}
