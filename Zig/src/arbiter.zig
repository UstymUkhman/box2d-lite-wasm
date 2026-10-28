const vec = @import("./root.zig").vec;
const Body = @import("body.zig").Body;

const expect = @import("std").testing.expect;
const collide = @import("collide.zig").collide;
const clamp = @import("./utils/math.zig").clamp;

const floatCrossVec2 = vec.floatCrossVec2;
const vec2CrossFloat = vec.vec2CrossFloat;
const vec2CrossVec2 = vec.vec2CrossVec2;
const vec2MulFloat = vec.vec2MulFloat;
const Vec2 = vec.Vec2;
const dot = vec.dot;

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
    num_contacts: usize = 0,

    body1: *Body = undefined,
    body2: *Body = undefined,

    contacts: [MAX_POINTS]Contact = undefined,

    pub fn init(body1: *Body, body2: *Body) @This()
    {
        var this = Arbiter {};

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

        return this;
    }

    pub fn update(this: *Arbiter, new_contacts: [*]Contact, num_contacts: usize) void
    {
        var merged_contracts: [2]Contact = undefined;

        for (0..num_contacts) |n|
        {
            var c : i32 = -1;
            const c_new = new_contacts[n];

            for (0..this.num_contacts) |o|
            {
                const c_old = this.contacts[o];

                if (c_new.feature.value == c_old.feature.value)
                {
                    c = @intCast(o);
                    break;
                }
            }

            if (c > -1)
            {
                merged_contracts[n] = c_new;
                var m = merged_contracts[n];

                if (false) // world.warm_starting)
                {
                    const c_old = this.contacts[@intCast(c)];

                    m.normal_impulse = c_old.normal_impulse;
                    m.tangent_impulse = c_old.tangent_impulse;
                    m.normal_bias_impulse = c_old.normal_bias_impulse;
                }
                else
                {
                    m.normal_impulse = 0;
                    m.tangent_impulse = 0;
                    m.normal_bias_impulse = 0;
                }
            }
            else
            {
                merged_contracts[n] = new_contacts[n];
            }
        }

        for (0..num_contacts) |c|
        {
            this.contacts[c] = merged_contracts[c];
        }

        this.num_contacts = num_contacts;
    }

    pub fn pre_step(this: *Arbiter, inv_dt: f32) void
    {
        const k_bias_factor = 0.0; // if (world.position_correction) 0.2 orelse 0.0;
        const k_allowed_penetration = 0.01;

        for (0..this.num_contacts) |c|
        {
            var contract = this.contacts[c];

            const r1 = contract.position.sub(&this.body1.position);
            const r2 = contract.position.sub(&this.body2.position);

            const rn1 = dot(&r1, &contract.normal);
            const rn2 = dot(&r2, &contract.normal);

            var k_normal = this.body1.inv_mass + this.body2.inv_mass;
            k_normal += this.body1.inv_i + (dot(&r1, &r1) - rn1 * rn1) + this.body2.inv_i * (dot(&r2, &r2) - rn2 * rn2);
            contract.mass_normal = 1 / k_normal;

            const tangent = vec2CrossFloat(&contract.normal, 1);

            const rt1 = dot(&r1, &tangent);
            const rt2 = dot(&r2, &tangent);

            var k_tangent = this.body1.inv_mass + this.body2.inv_mass;
            k_tangent += this.body1.inv_i * (dot(&r1, &r1) - rt1 * rt1) + this.body2.inv_i * (dot(&r2, &r2) - rt2 * rt2);
            contract.mass_tangent = 1 / k_tangent;

            contract.bias = -k_bias_factor * inv_dt * @min(0, contract.separation + k_allowed_penetration);

            if (false) // world.accumulate_impulses)
            {
                const p = vec2MulFloat(contract.normal, contract.normal_impulse)
                    .add(vec2MulFloat(tangent, contract.tangent_impulse));

                this.body1.velocity.subAssign(vec2MulFloat(p, this.body1.inv_mass));
                this.body1.angular_velocity -= this.body1.inv_i * vec2CrossVec2(r1, p);

                this.body2.velocity.addAssign(vec2MulFloat(p, this.body2.inv_mass));
                this.body2.angular_velocity += this.body2.inv_i * vec2CrossVec2(r2, p);
            }
        }
    }

    pub fn apply_impulse(this: *Arbiter) void
    {
        var b1 = this.body1;
        var b2 = this.body2;

        for (0..this.num_contacts) |c|
        {
            var contract = this.contacts[c];

            contract.r1 = contract.position.sub(&b1.position);
            contract.r2 = contract.position.sub(&b2.position);

            var vr1 = b1.velocity.add(&floatCrossVec2(b1.angular_velocity, &contract.r1));
            var dv = b2.velocity.add(&floatCrossVec2(b2.angular_velocity, &contract.r2));
            dv.subAssign(&vr1);

            const vn = dot(&dv, &contract.normal);
            var dPn = contract.mass_normal * (-vn + contract.bias);

            if (false) // world.accumulate_impulses)
            {
                const pn0 = contract.normal_impulse;
                contract.normal_impulse = @max(pn0 + dPn, 0);
                dPn = contract.normal_impulse - pn0;
            }
            else
            {
                dPn = @max(dPn, 0);
            }

            const pn = vec2MulFloat(&contract.normal, dPn);

            b1.velocity.subAssign(&vec2MulFloat(&pn, b1.inv_mass));
            b1.angular_velocity -= b1.inv_i * vec2CrossVec2(&contract.r1, &pn);

            b2.velocity.addAssign(&vec2MulFloat(&pn, b2.inv_mass));
            b2.angular_velocity += b2.inv_i * vec2CrossVec2(&contract.r2, &pn);

            vr1 = b1.velocity.add(&floatCrossVec2(b1.angular_velocity, &contract.r1));
            dv = b2.velocity.add(&floatCrossVec2(b2.angular_velocity, &contract.r2));
            dv.subAssign(&vr1);

            const tangent = vec2CrossFloat(&contract.normal, 1);
            const vt = dot(&dv, &tangent);
            var dPt = contract.mass_tangent * -vt;

            if (false) // world.accumulate_impulses)
            {
                const maxPt = this.friction * contract.normal_impulse;
                const old_tangent_impulse = contract.tangent_impulse;

                contract.tangent_impulse = clamp(old_tangent_impulse + dPt, -maxPt, maxPt);
                dPt = contract.tangent_impulse - old_tangent_impulse;
            }
            else
            {
                const maxPt = this.friction * dPn;
                dPt = clamp(dPt, -maxPt, maxPt);
            }

            const pt = vec2MulFloat(&tangent, dPt);

            b1.velocity.subAssign(&vec2MulFloat(&pt, b1.inv_mass));
            b1.angular_velocity -= b1.inv_i * vec2CrossVec2(&contract.r1, &pt);

            b2.velocity.addAssign(&vec2MulFloat(&pt, b2.inv_mass));
            b2.angular_velocity += b2.inv_i * vec2CrossVec2(&contract.r2, &pt);
        }
    }
};

test "basic functionality"
{
    var body = Body { .id = 0 };
    var arbiter = Arbiter.init(&body, &body);

    try expect(arbiter.num_contacts == 0);
    try expect(arbiter.friction == 0.2);

    const c0 = Contact { .normal_impulse = 0, .tangent_impulse = 1, .normal_bias_impulse = 2 };
    const c1 = Contact { .normal_impulse = 3, .tangent_impulse = 4, .normal_bias_impulse = 5 };

    var contracts = [_]Contact{ c0, c1 };
    arbiter.update(&contracts, 2);

    try expect(c0.normal_impulse == 0 and c0.tangent_impulse == 1 and c0.normal_bias_impulse == 2);
    try expect(c1.normal_impulse == 3 and c1.tangent_impulse == 4 and c1.normal_bias_impulse == 5);

    arbiter.pre_step(0);

    try expect(c0.mass_normal == 0 and c0.mass_tangent == 0 and c0.bias == 0);
    try expect(c1.mass_normal == 0 and c1.mass_tangent == 0 and c1.bias == 0);

    arbiter.apply_impulse();

    try expect(c0.normal_impulse == 0 and c0.tangent_impulse == 1);
    try expect(c1.normal_impulse == 3 and c1.tangent_impulse == 4);

    try expect(arbiter.body1.velocity.x == 0 and arbiter.body1.velocity.y == 0 and arbiter.body1.angular_velocity == 0);
    try expect(arbiter.body2.velocity.x == 0 and arbiter.body2.velocity.y == 0 and arbiter.body2.angular_velocity == 0);
}
