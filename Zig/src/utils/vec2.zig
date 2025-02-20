const expect = @import("std").testing.expect;

pub const Vec2 = packed struct
{
    x: f32 = 0,
    y: f32 = 0,

    pub fn set(this: *Vec2, x: f32, y: f32) void
    {
        this.x = x; this.y = y;
    }

    pub fn add(this: *Vec2, addend: *const Vec2) Vec2
    {
        return Vec2 { .x = this.x + addend.x, .y = this.y + addend.y };
    }

    pub fn addAssign(this: *Vec2, addend: *const Vec2) void
    {
        this.x += addend.x; this.y += addend.y;
    }

    pub fn sub(this: *Vec2, subtrahend: *const Vec2) Vec2
    {
        return Vec2 { .x = this.x - subtrahend.x, .y = this.y - subtrahend.y };
    }

    pub fn subAssign(this: *Vec2, subtrahend: *const Vec2) void
    {
        this.x -= subtrahend.x; this.y -= subtrahend.y;
    }

    pub fn mul(this: *Vec2, multiplicand: *const Vec2) Vec2
    {
        return Vec2 { .x = this.x * multiplicand.x, .y = this.y * multiplicand.y };
    }

    pub fn mulAssign(this: *Vec2, multiplicand: *const Vec2) void
    {
        this.x *= multiplicand.x; this.y *= multiplicand.y;
    }

    // pub fn abs(this: *Vec2) Vec2
    // {
    //     return Vec2 { .x = @abs(this.x), .y = @abs(this.y) };
    // }

    pub fn neg(this: *Vec2) Vec2
    {
        return Vec2 { .x = -this.x, .y = -this.y };
    }

    pub fn len(this: *Vec2) f32
    {
        return @sqrt(this.x * this.x + this.y * this.y);
    }
};

pub inline fn vec2CrossVec2(a: *const Vec2, b: *const Vec2) f32
{
    return a.x * b.y - a.y * b.x;
}

pub inline fn vec2CrossFloat(v: *const Vec2, f: f32) Vec2
{
    return Vec2 { .x = v.y * f, .y = v.x * -f };
}

pub inline fn floatCrossVec2(f: f32, v: *const Vec2) Vec2
{
    return Vec2 { .x = v.y * -f, .y = v.x * f };
}

pub inline fn dot(a: *const Vec2, b: *const Vec2) f32
{
    return a.x * b.x + a.y * b.y;
}

test "basic functionality"
{
    var vec = Vec2 {};
    try expect(vec.x == 0 and vec.y == 0);

    vec.set(5, 8);
    try expect(vec.x == 5 and vec.y == 8);

    var v = Vec2 { .x = 7, .y = 8 };
    const sum = vec.add(&v);
    try expect(sum.x == 12 and sum.y == 16);

    v = Vec2 { .x = 3, .y = -4 };
    vec.addAssign(&v);
    try expect(vec.x == 8 and vec.y == 4);

    v = Vec2 { .x = 6, .y = -4 };
    const sub = vec.sub(&v);
    try expect(sub.x == 2 and sub.y == 8);

    v = Vec2 { .x = -2, .y = 6 };
    vec.subAssign(&v);
    try expect(vec.x == 10 and vec.y == -2);

    v = Vec2 { .x = 0.5, .y = -8 };
    const prod = vec.mul(&v);
    try expect(prod.x == 5 and prod.y == 16);

    v = Vec2 { .x = 1.5, .y = 5 };
    vec.mulAssign(&v);
    try expect(vec.x == 15 and vec.y == -10);

    // const abs = vec.abs();
    // try expect(abs.x == 15 and abs.y == 10);

    const neg = vec.neg();
    try expect(neg.x == -15 and neg.y == 10);

    const len = vec.len();
    try expect(len == 18.027756);
}

test "math functions"
{
    var v1 = Vec2 { .x = 2, .y = 4 };
    v1 = floatCrossVec2(5, &v1);
    try expect(v1.x == -20 and v1.y == 10);

    v1 = vec2CrossFloat(&v1, 2);
    try expect(v1.x == 20 and v1.y == 40);

    var v2 = Vec2 { .x = 0.1, .y = 0.5 };
    try expect(vec2CrossVec2(&v1, &v2) == 6);

    v1 = Vec2 { .x = 1, .y = 1 };
    v2 = Vec2 { .x = 2, .y = 2 };
    try expect(dot(&v1, &v2) == 4);
}
