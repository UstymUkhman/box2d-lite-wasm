const std = @import("std");
const Vec2 = @import("vec2.zig").Vec2;
const Mat4 = @import("mat4.zig").Mat4;

pub const Random = struct
{
    prng: std.Random.DefaultPrng = undefined,

    pub fn init(this: *Random, io: std.Io, seed: ?u64) void
    {
        this.prng = std.Random.DefaultPrng.init(
            seed orelse @as(u64, @bitCast(std.Io.Clock.now(.real, io).toMilliseconds()))
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
