const std = @import("std");
const testing = std.testing;

pub const Vec2 = packed struct
{
    x: f32 = 0,
    y: f32 = 0,

    pub fn set(this: *Vec2, x: f32, y: f32) void
    {
        this.x = x; this.y = y;
    }

    pub fn add(this: *Vec2, addend: Vec2) Vec2
    {
        return Vec2 { .x = this.x + addend.x, .y = this.y + addend.y };
    }

    pub fn addAssign(this: *Vec2, addend: Vec2) void
    {
        this.x += addend.x; this.y += addend.y;
    }

    pub fn sub(this: *Vec2, subtrahend: Vec2) Vec2
    {
        return Vec2 { .x = this.x - subtrahend.x, .y = this.y - subtrahend.y };
    }

    pub fn subAssign(this: *Vec2, subtrahend: Vec2) void
    {
        this.x -= subtrahend.x; this.y -= subtrahend.y;
    }

    pub fn mul(this: *Vec2, multiplicand: Vec2) Vec2
    {
        return Vec2 { .x = this.x * multiplicand.x, .y = this.y * multiplicand.y };
    }

    pub fn mulAssign(this: *Vec2, multiplicand: Vec2) void
    {
        this.x *= multiplicand.x; this.y *= multiplicand.y;
    }

    pub fn abs(this: *Vec2) Vec2
    {
        return Vec2 { .x = @abs(this.x), .y = @abs(this.y) };
    }

    pub fn neg(this: *Vec2) Vec2
    {
        return Vec2 { .x = -this.x, .y = -this.y };
    }

    pub fn len(this: *const Vec2) f32
    {
        return @sqrt(this.x * this.x + this.y * this.y);
    }
};

test "basic functionality"
{
    var vec = Vec2 {};
    try testing.expect(vec.x == 0 and vec.y == 0);

    vec.set(5, 8);
    try testing.expect(vec.x == 5 and vec.y == 8);

    const sum = vec.add(Vec2 { .x = 7, .y = 8 });
    try testing.expect(sum.x == 12 and sum.y == 16);

    vec.addAssign(Vec2 { .x = 3, .y = -4 });
    try testing.expect(vec.x == 8 and vec.y == 4);

    const sub = vec.sub(Vec2 { .x = 6, .y = -4 });
    try testing.expect(sub.x == 2 and sub.y == 8);

    vec.subAssign(Vec2 { .x = -2, .y = 6 });
    try testing.expect(vec.x == 10 and vec.y == -2);

    const prod = vec.mul(Vec2 { .x = 0.5, .y = -8 });
    try testing.expect(prod.x == 5 and prod.y == 16);

    vec.mulAssign(Vec2 { .x = 1.5, .y = 5 });
    try testing.expect(vec.x == 15 and vec.y == -10);

    const abs = vec.abs();
    try testing.expect(abs.x == 15 and abs.y == 10);

    const neg = vec.neg();
    try testing.expect(neg.x == -15 and neg.y == 10);

    const len = vec.len();
    try testing.expect(len == 18.027756);
}
