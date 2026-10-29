const ArbiterKey = @import("arbiter.zig").ArbiterKey;
const Arbiter = @import("arbiter.zig").Arbiter;
const Vec2 = @import("./root.zig").vec.Vec2;
const Joint = @import("joint.zig").Joint;
const Body = @import("body.zig").Body;
const std = @import("std");

pub const World = struct
{
    iterations: i32,
    gravity: *const Vec2,

    bodies: std.ArrayList(Body) = .empty,
    joints: std.ArrayList(Joint) = .empty,
    arbiters: std.AutoHashMap(ArbiterKey, Arbiter),

    pub const accumulate_impulses: bool = true;
    pub const position_correction: bool = true;
    pub const warm_starting      : bool = true;

    pub fn init(alloc: std.mem.Allocator, gravity: *const Vec2, iterations: i32) @This()
    {
        const arbiters = std.AutoHashMap(ArbiterKey, Arbiter).init(alloc);

        const this = World {
            .iterations = iterations,
            .arbiters = arbiters,
            .gravity = gravity
        };

        return this;
    }
};
