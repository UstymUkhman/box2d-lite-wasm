const std = @import("std");
const Vec2 = @import("vec2.zig").Vec2;

pub const Mat4 = packed struct
{
    col1: Vec2 = Vec2 {},
    col2: Vec2 = Vec2 {},

    pub fn fromAngle(this: *Mat4, angle: f32) void
    {
        const cos = @cos(angle);
        const sin = @sin(angle);

        this.col1.x = cos;
        this.col1.y = sin;

        this.col2.x = -sin;
        this.col2.y =  cos;
    }

    pub fn fromVectors(this: *Mat4, col1: *const Vec2, col2: *const Vec2) void
    {
        this.col1.set(col1.x, col1.y);
        this.col2.set(col2.x, col2.y);
    }

    pub fn mul(this: *Mat4, multiplicand: *const Mat4) Mat4
    {
        var mat = Mat4 {};

        const col1 = this.mulVec2(&multiplicand.col1);
        const col2 = this.mulVec2(&multiplicand.col2);

        mat.fromVectors(&col1, &col2);
        return mat;
    }

    pub fn mulVec2(this: *Mat4, vec: *const Vec2) Vec2
    {
        return Vec2 {
            .x = this.col1.x * vec.x + this.col2.x * vec.y,
            .y = this.col1.y * vec.x + this.col2.y * vec.y
        };
    }

    pub fn add(this: *Mat4, addend: *const Mat4) Mat4
    {
        var mat = Mat4 {};

        const col1 = this.col1.add(&addend.col1);
        const col2 = this.col2.add(&addend.col2);

        mat.fromVectors(&col1, &col2);
        return mat;
    }

    pub fn transpose(this: *Mat4) Mat4
    {
        var mat = Mat4 {};

        const col1 = Vec2 { .x = this.col1.x, .y = this.col2.x };
        const col2 = Vec2 { .x = this.col1.y, .y = this.col2.y };

        mat.fromVectors(&col1, &col2);
        return mat;
    }

    pub fn invert(this: *Mat4) Mat4
    {
        const a = this.col1.x;
        const b = this.col2.x;
        const c = this.col1.y;
        const d = this.col2.y;

        var mat = Mat4 {};
        var det = a * d - b * c;
        std.debug.assert(det != 0.0);
        det = 1.0 / det;

        mat.col1.x =  det * d;
		mat.col1.y = -det * c;
        mat.col2.x = -det * b;
        mat.col2.y =  det * a;

        return mat;
    }

    // pub fn abs(this: *Mat4) void
    // {
    //     var col1 = this.col1.abs();
    //     var col2 = this.col2.abs();
    //     this.fromVectors(&col1, &col2);
    // }
};

test "basic functionality"
{
    var mat = Mat4 {};

    try std.testing.expect(
        mat.col1.x == 0 and
        mat.col1.y == 0 and
        mat.col2.x == 0 and
        mat.col2.y == 0
    );

    mat.fromAngle(0);

    try std.testing.expect(
        mat.col1.x == 1 and
        mat.col1.y == 0 and
        mat.col2.x == 0 and
        mat.col2.y == 1
    );

    var v1 = Vec2 { .x = 32, .y = -8 };
    var v2 = Vec2 { .x = -2, .y = 16 };

    mat.fromVectors(&v1, &v2);

    try std.testing.expect(
        mat.col1.x == 32 and
        mat.col1.y == -8 and
        mat.col2.x == -2 and
        mat.col2.y == 16
    );

    var mat4 = Mat4 {};
    mat4.fromAngle(1);
    mat4 = mat.mul(&mat4);

    try std.testing.expect(
        mat4.col1.x ==  15.606731 and
        mat4.col1.y ==   9.141117 and
        mat4.col2.x == -28.007675 and
        mat4.col2.y ==  15.376604
    );

    var vec = Vec2 { .x = 0.5, .y = 1.5 };
    vec = mat.mulVec2(&vec);
    try std.testing.expect(vec.x == 13 and vec.y == 20);

    mat4 = mat.add(&mat4);

    try std.testing.expect(
        mat4.col1.x ==  47.60673   and
        mat4.col1.y ==   1.1411171 and
        mat4.col2.x == -30.007675  and
        mat4.col2.y ==  31.376604
    );

    mat = mat.transpose();

    try std.testing.expect(
        mat.col1.x == 32 and
        mat.col1.y == -2 and
        mat.col2.x == -8 and
        mat.col2.y == 16
    );

    // mat.abs();

    // try std.testing.expect(
    //     mat.col1.x == 32 and
    //     mat.col1.y ==  2 and
    //     mat.col2.x ==  8 and
    //     mat.col2.y == 16
    // );

    mat.fromAngle(1);
    mat = mat.invert();

    try std.testing.expect(
        mat.col1.x ==  0.54030234 and
        mat.col1.y == -0.8414711  and
        mat.col2.x ==  0.8414711  and
        mat.col2.y ==  0.54030234
    );
}
