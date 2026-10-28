const std = @import("std");
const lib = @import("root.zig");

pub fn main() void
{
    const vec = lib.vec.Vec2 {};
    std.debug.print("vec {{ .x = {d}, .y = {d} }}\n", .{ vec.x, vec.y });

    var body = lib.body.Body { .id = 0 };
    std.debug.print("body {{ .mass = {}, .inv_mass = {} }}\n", .{ body.mass, body.inv_mass });
    std.debug.print("body {{ .i = {}, .inv_i = {} }}\n", .{ body.i, body.inv_i });

    body.set(&lib.vec.Vec2 { .x = 8, .y = 4 }, 2);
    std.debug.print("body {{ .mass = {}, .inv_mass = {} }}\n", .{ body.mass, body.inv_mass });
    std.debug.print("body {{ .i = {}, .inv_i = {} }}\n", .{ body.i, body.inv_i });

    const arbiter = lib.arbiter.Arbiter.init(&body, &body);
    std.debug.print("arbiter {{ .num_contacts = {}, .friction = {} }}\n", .{ arbiter.num_contacts, arbiter.friction });

    // World
    // Collide
}
