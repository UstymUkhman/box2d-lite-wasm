const std = @import("std");
const lib = @import("root.zig");

pub fn main() void
{
    var vec = lib.vec.Vec2 {};
    std.debug.print("vec {{ .x = {d}, .y = {d} }}\n", .{ vec.x, vec.y });

    var body = lib.body.Body {};
    std.debug.print("body {{ .mass = {}, .inv_mass = {} }}\n", .{ body.mass, body.inv_mass });
    std.debug.print("body {{ .i = {}, .inv_i = {} }}\n", .{ body.i, body.inv_i });

    body.set(&lib.vec.Vec2 { .x = 8, .y = 4 }, 2);
    std.debug.print("body {{ .mass = {}, .inv_mass = {} }}\n", .{ body.mass, body.inv_mass });
    std.debug.print("body {{ .i = {}, .inv_i = {} }}\n", .{ body.i, body.inv_i });

    // Arbiter
    // World
    // Collide

    var joint = lib.joint.Joint {};
    joint.set(&body, &body, &vec);
    // joint.preStep(42.0);
    // joint.applyImpulse();
}
