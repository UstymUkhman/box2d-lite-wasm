const std = @import("std");
const Vec2 = @import("vec2.zig").Vec2;
const Mat4 = @import("mat4.zig").Mat4;

pub const Random = struct
{
    prng: std.rand.DefaultPrng = undefined,

    pub fn init(this: *Random, seed: ?u64) void
    {
        this.prng = std.rand.DefaultPrng.init(
            seed orelse @as(u64, @bitCast(std.time.milliTimestamp()))
        );
    }

    pub fn inRange(this: *Random, low: ?f32, high: ?f32) f32
    {
        const l = low orelse -1; const h = high orelse 1;
        return (h - l) * this.prng.random().float(f32) + l;
    }
};

pub inline fn absVec2(vec: *const Vec2) Vec2
{
    return Vec2 { .x = @abs(vec.x), .y = @abs(vec.y) };
}

pub inline fn absMat4(mat: *const Mat4) Mat4
{
    var mat4 = Mat4 {};
    var col1 = absVec2(&mat.col1);
    var col2 = absVec2(&mat.col2);
    mat4.fromVectors(&col1, &col2);
    return mat4;
}

pub inline fn clamp(value: f32, low: f32, high: f32) f32
{
    return @max(low, @min(value, high));
}

pub inline fn swap(T: anytype, a: *T, b: *T) void
{
    const tmp = a.*; a.* = b.*; b.* = tmp;
}

pub inline fn sign(value: f32) f32
{
    return if (value > 0) 1 else -1;
}

test "random functions"
{
    var random = Random {};
    try std.testing.expect(@TypeOf(random.prng) == std.rand.DefaultPrng);

    random.init(null);
    var rnd = random.inRange(null, null);
    try std.testing.expect(rnd > -1 and rnd < 1);

    rnd = random.inRange(-16, -4);
    try std.testing.expect(rnd > -16 and rnd < -4);

    rnd = random.inRange(0, 10);
    try std.testing.expect(rnd > 0 and rnd < 10);
}

test "basic functions"
{
    var vec1 = Vec2 { .x = -2, .y = -1 };
    var vec2 = Vec2 { .x = -8, .y = 4 };

    var mat = Mat4 {};
    mat.fromVectors(&vec1, &vec2);

    vec1 = absVec2(&vec1);
    try std.testing.expect(vec1.x == 2 and vec1.y == 1);

    mat = absMat4(&mat);
    try std.testing.expect(
        mat.col1.x == 2 and
        mat.col1.y == 1 and
        mat.col2.x == 8 and
        mat.col2.y == 4
    );

    const less = clamp(2, -1, 1);
    const more = clamp(-0.5, 0, 1);
    try std.testing.expect(less == 1 and more == 0);

    var a: f32 = 16;
    var b: f32 = -8;
    swap(@TypeOf(a), &a, &b);
    try std.testing.expect(a == -8 and b == 16);

    a = sign(a); b = sign(b);
    try std.testing.expect(a == -1 and b == 1);
}
