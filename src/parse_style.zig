const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

const style = @import("style.zig");
const Style = style.Style;
const FontStyle = style.FontStyle;
const Color = style.Color;

const ParseState = enum {
    Parse8,
    ParseFgNon8,
    ParseFg256,
    ParseFgRed,
    ParseFgGreen,
    ParseFgBlue,
    ParseBgNon8,
    ParseBg256,
    ParseBgRed,
    ParseBgGreen,
    ParseBgBlue,
};

pub fn parseStyle(code: []const u8) ?Style {
    if (code.len == 0 or std.mem.eql(u8, code, "0") or std.mem.eql(u8, code, "00")) {
        return null;
    }

    var font_style = FontStyle{};
    var foreground: Color = .Default;
    var background: Color = .Default;

    var state = ParseState.Parse8;
    var red: u8 = 0;
    var green: u8 = 0;

    var iter = std.mem.split(code, ";");
    while (iter.next()) |str| {
        const part = std.fmt.parseInt(u8, str, 10) catch return null;

        switch (state) {
            .Parse8 => {
                switch (part) {
                    0 => font_style = FontStyle{},
                    1 => font_style.bold = true,
                    2 => font_style.dim = true,
                    3 => font_style.italic = true,
                    4 => font_style.underline = true,
                    5 => font_style.slowblink = true,
                    6 => font_style.rapidblink = true,
                    7 => font_style.reverse = true,
                    8 => font_style.hidden = true,
                    9 => font_style.crossedout = true,
                    20 => font_style.fraktur = true,
                    30 => foreground = Color.Black,
                    31 => foreground = Color.Red,
                    32 => foreground = Color.Green,
                    33 => foreground = Color.Yellow,
                    34 => foreground = Color.Blue,
                    35 => foreground = Color.Magenta,
                    36 => foreground = Color.Cyan,
                    37 => foreground = Color.White,
                    38 => state = ParseState.ParseFgNon8,
                    39 => foreground = Color.Default,
                    40 => background = Color.Black,
                    41 => background = Color.Red,
                    42 => background = Color.Green,
                    43 => background = Color.Yellow,
                    44 => background = Color.Blue,
                    45 => background = Color.Magenta,
                    46 => background = Color.Cyan,
                    47 => background = Color.White,
                    48 => state = ParseState.ParseBgNon8,
                    49 => background = Color.Default,
                    53 => font_style.overline = true,
                    else => {
                        return null;
                    },
                }
            },
            .ParseFgNon8 => {
                switch (part) {
                    5 => state = ParseState.ParseFg256,
                    2 => state = ParseState.ParseFgRed,
                    else => {
                        return null;
                    },
                }
            },
            .ParseFg256 => {
                foreground = Color{ .Fixed = part };
                state = ParseState.Parse8;
            },
            .ParseFgRed => {
                red = part;
                state = ParseState.ParseFgGreen;
            },
            .ParseFgGreen => {
                green = part;
                state = ParseState.ParseFgBlue;
            },
            .ParseFgBlue => {
                foreground = Color{
                    .RGB = .{
                        .r = red,
                        .g = green,
                        .b = part,
                    },
                };
                state = ParseState.Parse8;
            },
            .ParseBgNon8 => {
                switch (part) {
                    5 => state = ParseState.ParseBg256,
                    2 => state = ParseState.ParseBgRed,
                    else => {
                        return null;
                    },
                }
            },
            .ParseBg256 => {
                background = Color{ .Fixed = part };
                state = ParseState.Parse8;
            },
            .ParseBgRed => {
                red = part;
                state = ParseState.ParseBgGreen;
            },
            .ParseBgGreen => {
                green = part;
                state = ParseState.ParseBgBlue;
            },
            .ParseBgBlue => {
                background = Color{
                    .RGB = .{
                        .r = red,
                        .g = green,
                        .b = part,
                    },
                };
                state = ParseState.Parse8;
            },
        }
    }

    if (state != ParseState.Parse8)
        return null;

    return Style{
        .foreground = foreground,
        .background = background,
        .font_style = font_style,
    };
}

test "parse empty style" {
    expectEqual(@as(?Style, null), parseStyle(""));
    expectEqual(@as(?Style, null), parseStyle("0"));
    expectEqual(@as(?Style, null), parseStyle("00"));
}

test "parse bold style" {
    const actual = parseStyle("01");
    const expected = Style{
        .font_style = FontStyle.bold,
    };

    expectEqual(@as(?Style, expected), actual);
}

test "parse yellow style" {
    const actual = parseStyle("33");
    const expected = Style{
        .foreground = Color.Yellow,

        .font_style = FontStyle{},
    };

    expectEqual(@as(?Style, expected), actual);
}

test "parse some fixed color" {
    const actual = parseStyle("38;5;220;1");
    const expected = Style{
        .foreground = Color{ .Fixed = 220 },

        .font_style = FontStyle.bold,
    };

    expectEqual(@as(?Style, expected), actual);
}

test "parse some rgb color" {
    const actual = parseStyle("38;2;123;123;123;1");
    const expected = Style{
        .foreground = Color{ .RGB = .{ .r = 123, .g = 123, .b = 123 } },

        .font_style = FontStyle.bold,
    };

    expectEqual(@as(?Style, expected), actual);
}

test "parse wrong rgb color" {
    const actual = parseStyle("38;2;123");
    expectEqual(@as(?Style, null), actual);
}
