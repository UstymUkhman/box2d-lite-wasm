const std = @import("std");
const lib = @import("root.zig");

pub fn main(init: std.process.Init) !void
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

    const gravity = lib.vec.Vec2 { .x = 0, .y = -10 };
    var world = lib.world.World.init(init.gpa, &gravity, 10);

    // std.debug.print(
    //     "world {{ .warm_starting = {}, .accumulate_impulses = {}, .position_correction = {} }}\n",
    //     .{ lib.world.World.warm_starting, lib.world.World.accumulate_impulses, lib.world.World.position_correction }
    // );

    try world.add_body(&body);
    std.debug.print("world {{ .bodies = {} }}\n", .{ world.bodies.items.len });

    world.broad_phase();
    world.clear();

    // Collide
}
