const std = @import("std");

const style = @import("style.zig");
const Style = style.Style;
const FontStyle = style.FontStyle;
const Color = style.Color;

pub const Esc = "\x1B";
pub const Csi = Esc ++ "[";

pub const Reset = Csi ++ "0m";

pub const Prefix = struct {
    sty: Style,

    const Self = @This();

    pub fn format(
        value: Self,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) @TypeOf(writer).Error!void {
        if (value.sty.isDefault()) return;

        // Start the escape sequence
        try writer.writeAll(Csi);
        var written_something = false;

        // Font styles
        if (value.sty.font_style.bold) {
            written_something = true;
            try writer.writeAll("1");
        }
        if (value.sty.font_style.italic) {
            if (written_something) {
                try writer.writeAll(";");
            } else {
                written_something = true;
            }
            try writer.writeAll("3");
        }
        if (value.sty.font_style.underline) {
            if (written_something) {
                try writer.writeAll(";");
            } else {
                written_something = true;
            }
            try writer.writeAll("4");
        }

        // Foreground color
        if (value.sty.foreground) |clr| {
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
                .Fixed => |fixed| try std.fmt.format(writer, "38;5;{}", .{fixed}),
                .RGB => |rgb| try std.fmt.format(writer, "38;2;{};{};{}", .{ rgb.r, rgb.g, rgb.b }),
            }
        }

        // Background color
        if (value.sty.background) |clr| {
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
                .Fixed => |fixed| try std.fmt.format(writer, "48;5;{}", .{fixed}),
                .RGB => |rgb| try std.fmt.format(writer, "48;2;{};{};{}", .{ rgb.r, rgb.g, rgb.b }),
            }
        }

        // End the escape sequence
        try writer.writeAll("m");
    }
};

pub const Postfix = struct {
    sty: Style,

    const Self = @This();

    pub fn format(
        value: Self,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) @TypeOf(writer).Error!void {
        if (value.sty.isDefault()) return;

        try writer.writeAll(Reset);
    }
};
