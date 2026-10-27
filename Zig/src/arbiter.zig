const collide = @import("collide.zig").collide;
const expect = @import("std").testing.expect;
const Vec2 = @import("./root.zig").vec.Vec2;
const Body = @import("body.zig").Body;

const FeaturePair = union
{
    value: i32,

    e: struct
    {
         in_edge1: i8,
        out_edge1: i8,
         in_edge2: i8,
        out_edge2: i8
    }
};

pub const Contact = struct
{
    bias: f32 = 0,
    separation: f32 = 0,

    mass_normal: f32 = 0,
    mass_tangent: f32 = 0,

    normal_impulse: f32 = 0,
    tangent_impulse: f32 = 0,
    normal_bias_impulse: f32 = 0,

    feature: FeaturePair = undefined,

    r1: Vec2 = Vec2 { .x = 0, .y = 0 },
    r2: Vec2 = Vec2 { .x = 0, .y = 0 },

    normal: Vec2 = Vec2 { .x = 0, .y = 0 },
    position: Vec2 = Vec2 { .x = 0, .y = 0 },
};

const ArbiterKey = struct
{
    body1: *Body = undefined,
    body2: *Body = undefined,

    pub fn set(this: *ArbiterKey, body1: *Body, body2: *Body) void
    {
        if (body1.id < body2.id)
        {
            this.body1 = body1;
            this.body2 = body2;
        }
        else
        {
            this.body1 = body2;
            this.body2 = body1;
        }
    }
};

pub const Arbiter = struct
{
    const MAX_POINTS = 2;

    friction: f32 = 0,
    num_contacts: i32 = 0,

    body1: *Body = undefined,
    body2: *Body = undefined,

    contacts: [MAX_POINTS]Contact = undefined,

    pub fn set(this: *Arbiter, body1: *Body, body2: *Body) void
    {
        if (body1.id < body2.id)
        {
            this.body1 = body1;
            this.body2 = body2;
        }
        else
        {
            this.body1 = body2;
            this.body2 = body1;
        }

        this.num_contacts = collide(&this.contacts, this.body1, this.body2);
        this.friction = @sqrt(this.body1.friction * this.body2.friction);
    }

    // pub fn update(this: *Arbiter, new_contacts: [*]Contact, num_contacts: i32) void
    // {}
    //
    // pub fn pre_step(inv_dt: f32) void
    // {}
    //
    // pub fn apply_impulse() void
    // {}
};

test "basic functionality"
{
    var body = Body { .id = 0 };
    var arbiter = Arbiter {};
    arbiter.set(&body, &body);

    try expect(arbiter.num_contacts == 0);
    try expect(arbiter.friction == 0.2);
}
