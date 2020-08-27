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

const font_style_codes = std.ComptimeStringMap([]const u8, .{
    .{ "bold", "1" },
    .{ "dim", "2" },
    .{ "italic", "3" },
    .{ "underline", "4" },
    .{ "slowblink", "5" },
    .{ "rapidblink", "6" },
    .{ "reverse", "7" },
    .{ "hidden", "8" },
    .{ "crossedout", "9" },
    .{ "fraktur", "20" },
    .{ "overline", "53" },
});

/// Update the current style of the ANSI terminal
pub fn updateStyle(writer: anytype, new: Style, old: ?Style) !void {
    // TODO: intelligent, "delta" style update
    if (old) |sty| if (new.eql(sty)) return;
    if (new.isDefault()) return try resetStyle(writer);

    // Start the escape sequence
    try writer.writeAll(Csi);
    var written_something = false;

    // Font styles
    inline for (std.meta.fields(FontStyle)) |field| {
        if (@field(new.font_style, field.name)) {
            comptime const code = font_style_codes.get(field.name).?;
            if (written_something) {
                try writer.writeAll(";");
            } else {
                written_something = true;
            }
            try writer.writeAll(code);
        }
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

test "bold style" {
    var buf: [1024]u8 = undefined;
    var fixed_buf_stream = fixedBufferStream(&buf);

    try updateStyle(fixed_buf_stream.writer(), Style{
        .font_style = FontStyle.bold,
    }, Style{});

    const expected = "\x1B[1m";
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
