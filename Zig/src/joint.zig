const vec = @import("./root.zig").vec;
const vec2MulFloat = vec.vec2MulFloat;
const vec2CrossVec2 = vec.vec2CrossVec2;
const floatCrossVec2 = vec.floatCrossVec2;

const expect = @import("std").testing.expect;
const Mat4 = @import("./root.zig").mat.Mat4;
const World = @import("world.zig").World;
const Body = @import("body.zig").Body;
const Vec2 = vec.Vec2;

pub const Joint = struct
{
    m: Mat4 = Mat4 {},

    softness:    f32 = 0,
    bias_factor: f32 = 0.2,

    body1: *Body = undefined,
    body2: *Body = undefined,

    r1: Vec2 = Vec2 { .x = 0, .y = 0 },
    r2: Vec2 = Vec2 { .x = 0, .y = 0 },

    bias:    Vec2 = Vec2 { .x = 0, .y = 0 },
    impulse: Vec2 = Vec2 { .x = 0, .y = 0 },

    local_anchor1: Vec2 = Vec2 { .x = 0, .y = 0 },
    local_anchor2: Vec2 = Vec2 { .x = 0, .y = 0 },

    pub fn set(this: *Joint, body1: *Body, body2: *Body, anchor: *Vec2) void
    {
        this.body1 = body1;
        this.body2 = body2;

        var rot1 = Mat4 {};
        var rot2 = Mat4 {};

        rot1.fromAngle(body1.rotation);
        rot2.fromAngle(body1.rotation);

        rot1 = rot1.transpose();
        rot2 = rot2.transpose();

        this.local_anchor1 = rot1.mulVec2(&anchor.sub(&body1.position));
        this.local_anchor2 = rot2.mulVec2(&anchor.sub(&body2.position));

        this.softness = 0.0;
        this.bias_factor = 0.2;
        this.impulse.set(0.0, 0.0);
    }

    pub fn preStep(this: *Joint, inv_dt: f32) void
    {
        var rot1 = Mat4 {};
        rot1.fromAngle(this.body1.rotation);

        var rot2 = Mat4 {};
        rot2.fromAngle(this.body2.rotation);

        this.r1 = rot1.mulVec2(&this.local_anchor1);
        this.r2 = rot2.mulVec2(&this.local_anchor2);

        var k1 = Mat4 {};
        k1.col1.x = this.body1.inv_mass + this.body2.inv_mass;
        k1.col1.y = 0;
        k1.col2.x = 0;
        k1.col2.y = this.body1.inv_mass + this.body2.inv_mass;

        var k2 = Mat4 {};
        k2.col1.x =  this.body1.inv_i * this.r1.y * this.r1.y;
        k2.col1.y = -this.body1.inv_i * this.r1.x * this.r1.y;
        k2.col2.x = -this.body1.inv_i * this.r1.x * this.r1.y;
        k2.col2.y =  this.body1.inv_i * this.r1.x * this.r1.x;

        var k3 = Mat4 {};
        k3.col1.x =  this.body2.inv_i * this.r2.y * this.r2.y;
        k3.col1.y = -this.body2.inv_i * this.r2.x * this.r2.y;
        k3.col2.x = -this.body2.inv_i * this.r2.x * this.r2.y;
        k3.col2.y =  this.body2.inv_i * this.r2.x * this.r2.x;

        var k = k1.add(&k2.add(&k3));
        k.col1.x += this.softness;
        k.col2.y += this.softness;

        this.m = k.invert();

        const p1 = this.body1.position.add(&this.r1);
        var p2 = this.body2.position.add(&this.r2);
        const dp = p2.sub(&p1);

        if (World.position_correction)
        {
            this.bias = vec2MulFloat(&vec2MulFloat(&dp, inv_dt), -this.bias_factor);
        }
        else
        {
            this.bias.set(0, 0);
        }

        if (World.warm_starting)
        {
            this.body1.velocity.subAssign(&vec2MulFloat(&this.impulse, this.body1.inv_mass));
            this.body1.angular_velocity -= this.body1.inv_i * vec2CrossVec2(&this.r1, &this.impulse);

            this.body2.velocity.addAssign(&vec2MulFloat(&this.impulse, this.body2.inv_mass));
            this.body2.angular_velocity += this.body2.inv_i * vec2CrossVec2(&this.r2, &this.impulse);
        }
        else
        {
            this.impulse.set(0, 0);
        }
    }

    pub fn applyImpulse(this: *Joint) void
    {
        var dv = floatCrossVec2(this.body2.angular_velocity, &this.r2);
        dv.addAssign(&this.body2.velocity);
        dv.subAssign(&this.body1.velocity);
        dv.subAssign(&floatCrossVec2(this.body1.angular_velocity, &this.r1));

        var impulse = this.bias.sub(&dv);
        impulse.subAssign(&vec2MulFloat(&this.impulse, this.softness));
        impulse = this.m.mulVec2(&impulse);

        this.body1.velocity.subAssign(&vec2MulFloat(&impulse, this.body1.inv_mass));
        this.body1.angular_velocity -= this.body1.inv_i * vec2CrossVec2(&this.r1, &impulse);

        this.body2.velocity.addAssign(&vec2MulFloat(&impulse, this.body2.inv_mass));
        this.body2.angular_velocity += this.body2.inv_i * vec2CrossVec2(&this.r2, &impulse);

        this.impulse.addAssign(&impulse);
    }
};

test "basic functionality"
{
    var joint = Joint {};
    var body = Body { .id = 0 };
    var v2 = Vec2 { .x = 1, .y = 1 };

    body.set(&v2, 1);
    joint.set(&body, &body, &v2);

    try expect(joint.local_anchor1.x == 1 and joint.local_anchor1.y == 1);
    try expect(joint.local_anchor2.x == 1 and joint.local_anchor2.y == 1);

    try expect(joint.softness  == 0 and joint.bias_factor == 0.2);
    try expect(joint.impulse.x == 0 and joint.impulse.y   == 0  );

    joint.preStep(0);

    try expect(joint.m.col1.x == 0.26923078 and joint.m.col1.y == 0.23076925);
    try expect(joint.m.col2.x == 0.23076925 and joint.m.col2.y == 0.26923078);

    joint.applyImpulse();
    try expect(joint.impulse.x == 0 and joint.impulse.y == 0);
}
