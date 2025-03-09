const esc = "\x1B";
const csi = esc ++ "[";

pub fn disableLineWrap(writer: anytype) !void {
    try writer.writeAll(csi ++ "?7l");
}

pub fn enableLineWrap(writer: anytype) !void {
    try writer.writeAll(csi ++ "?7h");
}

pub fn saveScreen(writer: anytype) !void {
    try writer.writeAll(csi ++ "?47h");
}

pub fn restoreScreen(writer: anytype) !void {
    try writer.writeAll(csi ++ "?47l");
}

pub fn enterAlternateScreen(writer: anytype) !void {
    try writer.writeAll(csi ++ "?1049h");
}

pub fn leaveAlternateScreen(writer: anytype) !void {
    try writer.writeAll(csi ++ "?1049l");
}

pub fn setSize(writer: anytype, columns: u16, rows: u16) !void {
    try writer.print(csi ++ "8;{d};{d}t", .{ rows, columns });
}

pub fn setTitle(writer: anytype, title: []const u8) !void {
    try writer.print(esc ++ "]0;{s}\x07", .{title});
}

pub fn beginSynchronizedUpdate(writer: anytype) !void {
    try writer.writeAll(csi ++ "?2026h");
}

pub fn endSynchronizedUpdate(writer: anytype) !void {
    try writer.writeAll(csi ++ "?2026l");
}
