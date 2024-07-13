const std = @import("std");

const esc = "\x1B";
const csi = esc ++ "[";

pub fn clearCurrentLine(writer: anytype) !void {
    if (!writer.supportsAnsiEscapeCodes()) return error.UnsupportedAnsiEscapeCodes;
    try writer.writeAll(csi ++ "2K");
}

pub fn clearFromCursorToLineBeginning(writer: anytype) !void {
    if (!writer.supportsAnsiEscapeCodes()) return error.UnsupportedAnsiEscapeCodes;
    try writer.writeAll(csi ++ "1K");
}

pub fn clearFromCursorToLineEnd(writer: anytype) !void {
    if (!writer.supportsAnsiEscapeCodes()) return error.UnsupportedAnsiEscapeCodes;
    try writer.writeAll(csi ++ "K");
}

pub fn clearScreen(writer: anytype) !void {
    if (!writer.supportsAnsiEscapeCodes()) return error.UnsupportedAnsiEscapeCodes;
    try writer.writeAll(csi ++ "2J");
}

pub fn clearFromCursorToScreenBeginning(writer: anytype) !void {
    if (!writer.supportsAnsiEscapeCodes()) return error.UnsupportedAnsiEscapeCodes;
    try writer.writeAll(csi ++ "1J");
}

pub fn clearFromCursorToScreenEnd(writer: anytype) !void {
    if (!writer.supportsAnsiEscapeCodes()) return error.UnsupportedAnsiEscapeCodes;
    try writer.writeAll(csi ++ "J");
}
