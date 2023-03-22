const std = @import("std");
const testing = std.testing;
const fixedBufferStream = std.io.fixedBufferStream;
const esc = "\x1B";
const csi = esc ++ "[";

pub const CursorMode = enum(u8) {
    blinking_block = 1,
    block,
    blinking_underscore,
    underscore,
    blinking_I_beam,
    I_beam,
};

pub fn setCursorMode(writer: anytype, mode: CursorMode) !void {
    const modeNumber = @enumToInt(mode);
    try writer.print(csi ++ "{d} q", .{modeNumber});
}

pub fn hideCursor(writer: anytype) !void {
    try writer.writeAll(csi ++ "?25l");
}

pub fn showCursor(writer: anytype) !void {
    try writer.writeAll(csi ++ "?25h");
}

pub fn saveCursor(writer: anytype) !void {
    try writer.writeAll(csi ++ "s");
}

pub fn restoreCursor(writer: anytype) !void {
    try writer.writeAll(csi ++ "u");
}

pub fn setCursor(writer: anytype, x: usize, y: usize) !void {
    try writer.print(csi ++ "{};{}H", .{ y + 1, x + 1 });
}

pub fn setCursorRow(writer: anytype, row: usize) !void {
    try writer.print(csi ++ "{}H", .{row + 1});
}

pub fn setCursorColumn(writer: anytype, column: usize) !void {
    try writer.print(csi ++ "{}G", .{column + 1});
}

pub fn cursorUp(writer: anytype, lines: usize) !void {
    try writer.print(csi ++ "{}A", .{lines});
}

pub fn cursorDown(writer: anytype, lines: usize) !void {
    try writer.print(csi ++ "{}B", .{lines});
}

pub fn cursorForward(writer: anytype, columns: usize) !void {
    try writer.print(csi ++ "{}C", .{columns});
}

pub fn cursorBackward(writer: anytype, columns: usize) !void {
    try writer.print(csi ++ "{}D", .{columns});
}

pub fn cursorNextLine(writer: anytype, lines: usize) !void {
    try writer.print(csi ++ "{}E", .{lines});
}

pub fn cursorPreviousLine(writer: anytype, lines: usize) !void {
    try writer.print(csi ++ "{}F", .{lines});
}

pub fn scrollUp(writer: anytype, lines: usize) !void {
    try writer.print(csi ++ "{}S", .{lines});
}

pub fn scrollDown(writer: anytype, lines: usize) !void {
    try writer.print(csi ++ "{}T", .{lines});
}

test "test cursor mode BLINKING_UNDERSCORE" {
    var buf: [1024]u8 = undefined;
    var fixed_buf_stream = fixedBufferStream(&buf);

    try setCursorMode(fixed_buf_stream.writer(), .blinking_underscore);
    // the space is needed
    const expected = csi ++ "3 q";
    const actual = fixed_buf_stream.getWritten();

    try testing.expectEqualSlices(u8, expected, actual);
}

test "test cursor mode BLINKING_I_BEAM" {
    var buf: [1024]u8 = undefined;
    var fixed_buf_stream = fixedBufferStream(&buf);

    try setCursorMode(fixed_buf_stream.writer(), .blinking_I_beam);
    // the space is needed
    const expected = csi ++ "5 q";
    const actual = fixed_buf_stream.getWritten();

    try testing.expectEqualSlices(u8, expected, actual);
}
