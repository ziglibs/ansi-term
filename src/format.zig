const std = @import("std");
const fixedBufferStream = std.io.fixedBufferStream;
const testing = std.testing;

const style = @import("style.zig");
const Style = style.Style;
const FontStyle = style.FontStyle;
const Color = style.Color;

pub const Esc = "\x1B";
pub const Csi = Esc ++ "[";

pub const Reset = Csi ++ "0m";

/// Update the current style of the ANSI terminal
pub fn updateStyle(writer: anytype, new: Style, old: ?Style) !void {
    // TODO: intelligent, "delta" style update
    if (old) |sty| if (new.eql(sty)) return;

    // Start the escape sequence
    try writer.writeAll(Csi);
    var written_something = false;

    // Font styles
    if (new.font_style.bold) {
        written_something = true;
        try writer.writeAll("1");
    }
    if (new.font_style.dim) {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }
        try writer.writeAll("2");
    }
    if (new.font_style.italic) {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }
        try writer.writeAll("3");
    }
    if (new.font_style.underline) {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }
        try writer.writeAll("4");
    }

    if (new.font_style.slowblink) {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }
        try writer.writeAll("5");
    }

    if (new.font_style.rapidblink) {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }
        try writer.writeAll("6");
    }

    if (new.font_style.reverse) {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }
        try writer.writeAll("7");
    }

    if (new.font_style.hidden) {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }
        try writer.writeAll("8");
    }

    if (new.font_style.crossedout) {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }
        try writer.writeAll("9");
    }

    if (new.font_style.fraktur) {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }
        try writer.writeAll("20");
    }

    if (new.font_style.overline) {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }
        try writer.writeAll("53");
    }

    // Foreground color
    if (new.foreground) |clr| {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }

        switch (clr) {
            .Black => try writer.writeAll("30"),
            .Red => try writer.writeAll("31"),
            .Green => try writer.writeAll("32"),
            .Yellow => try writer.writeAll("33"),
            .Blue => try writer.writeAll("34"),
            .Magenta => try writer.writeAll("35"),
            .Cyan => try writer.writeAll("36"),
            .White => try writer.writeAll("37"),
            .Fixed => |fixed| try writer.print("38;5;{}", .{fixed}),
            .RGB => |rgb| try writer.print("38;2;{};{};{}", .{ rgb.r, rgb.g, rgb.b }),
        }
    }

    // Background color
    if (new.background) |clr| {
        if (written_something) {
            try writer.writeAll(";");
        } else {
            written_something = true;
        }

        switch (clr) {
            .Black => try writer.writeAll("40"),
            .Red => try writer.writeAll("41"),
            .Green => try writer.writeAll("42"),
            .Yellow => try writer.writeAll("43"),
            .Blue => try writer.writeAll("44"),
            .Magenta => try writer.writeAll("45"),
            .Cyan => try writer.writeAll("46"),
            .White => try writer.writeAll("47"),
            .Fixed => |fixed| try writer.print("48;5;{}", .{fixed}),
            .RGB => |rgb| try writer.print("48;2;{};{};{}", .{ rgb.r, rgb.g, rgb.b }),
        }
    }

    // End the escape sequence
    try writer.writeAll("m");
}

test "same style, no update" {
    var buf: [1024]u8 = undefined;
    var fixed_buf_stream = fixedBufferStream(&buf);

    try updateStyle(fixed_buf_stream.writer(), Style{}, Style{});

    const expected = "";
    const actual = fixed_buf_stream.getWritten();

    testing.expectEqualSlices(u8, expected, actual);
}

pub fn resetStyle(writer: anytype) !void {
    try writer.writeAll(Csi ++ "0m");
}

test "reset style" {
    var buf: [1024]u8 = undefined;
    var fixed_buf_stream = fixedBufferStream(&buf);

    try resetStyle(fixed_buf_stream.writer());

    const expected = "\x1B[0m";
    const actual = fixed_buf_stream.getWritten();

    testing.expectEqualSlices(u8, expected, actual);
}
