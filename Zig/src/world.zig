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
    alloc: std.mem.Allocator,

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
            .gravity = gravity,
            .alloc = alloc
        };

        return this;
    }

    pub fn add_joint(this: *World, joint: *const Joint) !void
    {
        try this.joints.append(this.alloc, joint.*);
    }

    pub fn add_body(this: *World, body: *const Body) !void
    {
        try this.bodies.append(this.alloc, body.*);
    }

    pub fn clear(this: *World) void
    {
        this.joints.clearAndFree(this.alloc);
        this.bodies.clearAndFree(this.alloc);
        this.arbiters.clearAndFree();
    }

    pub fn broad_phase(this: *World) void
    {
        for (this.bodies.items) |*bi|
        {
            for (this.bodies.items) |*bj|
            {
                if (bi.*.inv_mass == 0 and bj.*.inv_mass == 0)
                {
                    continue;
                }

                const key = ArbiterKey.init(bi, bj);
                var new_arb = Arbiter.init(bi, bj);

                if (new_arb.num_contacts > 0)
                {
                    var iter = this.arbiters.get(key);

                    if (iter == null)
                    {
                        this.arbiters.putAssumeCapacity(key, new_arb);
                    }
                    else
                    {
                        iter.?.update(&new_arb.contacts, new_arb.num_contacts);
                    }
                }
                else
                {
                    _ = this.arbiters.remove(key);
                }
            }
        }
    }
};
