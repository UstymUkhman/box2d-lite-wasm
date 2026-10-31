const Contact = @import("arbiter.zig").Contact;
const Body = @import("body.zig").Body;

pub fn collide(contacts: [*]Contact, body1: *const Body, body2: *const Body) usize
{
    _ = contacts;
    _ = body1;
    _ = body2;

    return 0;
}
