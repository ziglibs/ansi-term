const std = @import("std");

const Esc = "\x1B";
const Csi = Esc ++ "[";

pub fn clearCurrentLine(writer: anytype) !void {
    try writer.writeAll(Csi ++ "2K");
}

pub fn clearFromCursorToLineBeginning(writer: anytype) !void {
    try writer.writeAll(Csi ++ "1K");
}

pub fn clearFromCursorToLineEnd(writer: anytype) !void {
    try writer.writeAll(Csi ++ "K");
}

pub fn clearScreen(writer: anytype) !void {
    try writer.writeAll(Csi ++ "2J");
}

pub fn clearFromCursorToScreenBeginning(writer: anytype) !void {
    try writer.writeAll(Csi ++ "1J");
}

pub fn clearFromCursorToScreenEnd(writer: anytype) !void {
    try writer.writeAll(Csi ++ "J");
}
