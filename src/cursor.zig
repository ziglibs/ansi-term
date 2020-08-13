const std = @import("std");

const Esc = "\x1B";
const Csi = Esc ++ "[";

pub fn hideCursor(writer: anytype) !void {
    try writer.writeAll(Csi ++ "?25l");
}

pub fn showCursor(writer: anytype) !void {
    try writer.writeAll(Csi ++ "?25h");
}

pub fn saveCursor(writer: anytype) !void {
    try writer.writeAll(Csi ++ "s");
}

pub fn restoreCursor(writer: anytype) !void {
    try writer.writeAll(Csi ++ "u");
}

pub fn setCursor(writer: anytype, x: usize, y: usize) !void {
    try writer.print(Csi ++ "{};{}H", .{ y + 1, x + 1 });
}

pub fn setCursorRow(writer: anytype, row: usize) !void {
    try writer.print(Csi ++ "{}H", .{row + 1});
}

pub fn setCursorColumn(writer: anytype, column: usize) !void {
    try writer.print(Csi ++ "{}G", .{column + 1});
}

pub fn cursorUp(writer: anytype, lines: usize) !void {
    try writer.print(Csi ++ "{}A", .{lines});
}

pub fn cursorDown(writer: anytype, lines: usize) !void {
    try writer.print(Csi ++ "{}B", .{lines});
}

pub fn cursorForward(writer: anytype, columns: usize) !void {
    try writer.print(Csi ++ "{}C", .{columns});
}

pub fn cursorBackward(writer: anytype, columns: usize) !void {
    try writer.print(Csi ++ "{}D", .{columns});
}

pub fn cursorNextLine(writer: anytype, lines: usize) !void {
    try writer.print(Csi ++ "{}E", .{lines});
}

pub fn cursorPreviousLine(writer: anytype, lines: usize) !void {
    try writer.print(Csi ++ "{}F", .{lines});
}

pub fn scrollUp(writer: anytype, lines: usize) !void {
    try writer.print(Csi ++ "{}S", .{lines});
}

pub fn scrollDown(writer: anytype, lines: usize) !void {
    try writer.print(Csi ++ "{}T", .{lines});
}
