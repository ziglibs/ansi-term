const std = @import("std");

pub const cursor = @import("cursor.zig");
pub const clear = @import("clear.zig");
pub const style = @import("style.zig");
pub const format = @import("format.zig");

test {
    std.testing.refAllDeclsRecursive(@This());
}
