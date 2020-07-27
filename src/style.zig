const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

pub const ColorRGB = struct {
    r: u8,
    g: u8,
    b: u8,

    const Self = @This();

    pub fn eql(self: Self, other: Self) bool {
        return self.r == other.r and
            self.g == other.g and
            self.b == other.b;
    }
};

pub const Color = union(enum) {
    Black,
    Red,
    Green,
    Yellow,
    Blue,
    Magenta,
    Cyan,
    White,
    Fixed: u8,
    RGB: ColorRGB,

    const Self = @This();

    pub fn eql(self: Self, other: Self) bool {
        return switch (self) {
            .Black => other == .Black,
            .Red => other == .Red,
            .Green => other == .Green,
            .Yellow => other == .Yellow,
            .Blue => other == .Blue,
            .Magenta => other == .Magenta,
            .Cyan => other == .Cyan,
            .White => other == .White,
            .Fixed => |x| switch (other) {
                .Fixed => |y| x == y,
                else => false,
            },
            .RGB => |x| switch (other) {
                .RGB => |y| x.eql(y),
                else => false,
            },
        };
    }
};

pub const FontStyle = struct {
    bold: bool,
    italic: bool,
    underline: bool,

    const Self = @This();

    pub const default = Self{
        .bold = false,
        .italic = false,
        .underline = false,
    };

    pub const bold = Self{
        .bold = true,
        .italic = false,
        .underline = false,
    };

    pub const italic = Self{
        .bold = false,
        .italic = true,
        .underline = false,
    };

    pub const underline = Self{
        .bold = false,
        .italic = false,
        .underline = true,
    };

    pub fn isDefault(self: Self) bool {
        return !self.bold and !self.italic and !self.underline;
    }

    pub fn eql(self: Self, other: Self) bool {
        return self.bold == other.bold and
            self.italic == other.italic and
            self.underline == other.underline;
    }
};

pub const Style = struct {
    foreground: ?Color,
    background: ?Color,
    font_style: FontStyle,

    const Self = @This();

    pub const default = Self{
        .foreground = null,
        .background = null,
        .font_style = FontStyle.default,
    };

    pub fn eql(self: Self, other: Self) bool {
        if (self.foreground) |x| {
            if (other.foreground) |y| {
                if (!x.eql(y)) return false;
            } else {
                return false;
            }
        } else {
            if (other.foreground) |_| return false;
        }

        if (self.background) |x| {
            if (other.background) |y| {
                if (!x.eql(y)) return false;
            } else {
                return false;
            }
        } else {
            if (other.background) |_| return false;
        }

        return self.font_style.eql(other.font_style);
    }

    pub fn isDefault(self: Self) bool {
        return self.foreground == null and self.background == null and self.font_style.isDefault();
    }
};

test "style equality" {
    const a = Style.default;
    const b = Style{
        .foreground = null,
        .background = null,
        .font_style = FontStyle.bold,
    };
    const c = Style{
        .foreground = Color.Red,
        .background = null,
        .font_style = FontStyle.default,
    };

    expect(a.eql(a));
    expect(b.eql(b));
    expect(c.eql(c));

    expect(!a.eql(b));
    expect(!b.eql(a));
    expect(!a.eql(c));
}
