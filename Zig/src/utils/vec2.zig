pub const Vec2 = struct
{
    x: f32 = 0,
    y: f32 = 0,

    pub fn set(this: *Vec2, x: f32, y: f32) void
    {
        this.x = x; this.y = y;
    }

    pub fn assign(this: *Vec2, assignor: *const Vec2) void
    {
        this.x = assignor.x; this.y = assignor.y;
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

    pub fn abs(this: *Vec2) void
    {
        this.x = @abs(this.x); this.y = @abs(this.y);
    }

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

pub inline fn vec2MulFloat(v: *const Vec2, f: f32) Vec2
{
    return Vec2 { .x = v.x * f, .y = v.y * f };
}

pub inline fn dot(a: *const Vec2, b: *const Vec2) f32
{
    return a.x * b.x + a.y * b.y;
}
