const std = @import("std");

const esc = "\x1B";
const csi = esc ++ "[";

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
