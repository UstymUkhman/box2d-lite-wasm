const std = @import("std");
const Vec2 = @import("./root.zig").vec.Vec2;
const expect = @import("std").testing.expect;

pub const Body = struct
{
    position: Vec2 = Vec2 { .x = 0, .y = 0 },
    rotation: f32 = 0,

    velocity: Vec2 = Vec2 { .x = 0, .y = 0 },
    angular_velocity: f32 = 0,

    width: Vec2 = Vec2 { .x = 1, .y = 1 },
    friction: f32 = 0.2,

    force: Vec2 = Vec2 { .x = 0, .y = 0 },
    torque: f32 = 0,

    mass: f32 = std.math.floatMax(f32),
    inv_mass: f32 = 0,

    i: f32 = std.math.floatMax(f32),
    inv_i: f32 = 0,

    pub fn set(this: *Body, width: *const Vec2, mass: f32) void
    {
        this.position.set(0, 0);
        this.rotation = 0;

        this.velocity.set(0, 0);
        this.angular_velocity = 0;

        this.width.assign(width);
        this.friction = 0;

        this.force.set(0, 0);
        this.torque = 0;

        this.mass = mass;

        if (mass < std.math.floatMax(f32))
        {
            this.inv_mass = 1 / mass;
            this.i = mass * (width.x * width.x + width.y * width.y) / 12;
            this.inv_i = 1 / this.i;
        }
        else
        {
            this.inv_mass = 0;
            this.i = std.math.floatMax(f32);
            this.inv_i = 0;
        }
    }

    pub fn addForce(this: *Body, force: *const Vec2) void
    {
        this.force.addAssign(force);
    }
};
