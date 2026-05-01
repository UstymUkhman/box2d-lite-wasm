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

test "basic functionality"
{
    var body = Body {};
    try expect(body.position.x == 0 and body.position.y == 0 and body.rotation == 0);
    try expect(body.velocity.x == 0 and body.velocity.y == 0 and body.angular_velocity == 0);
    try expect(body.width.x == 1 and body.width.y == 1 and body.friction == 0.2);

    try expect(body.force.x == 0 and body.force.y == 0 and body.torque == 0);
    try expect(body.mass == std.math.floatMax(f32) and body.inv_mass == 0);
    try expect(body.i == std.math.floatMax(f32) and body.inv_i == 0);

    const width = Vec2 { .x = 8, .y = 4 };
    body.set(&width, 2);

    try expect(body.mass == 2 and body.inv_mass == 0.5);
    try expect(body.i == 13.333333 and body.inv_i == 0.075);

    body.addForce(&.{ .x = 2, .y = 4 });
    try expect(body.force.x == 2 and body.force.y == 4);
}
