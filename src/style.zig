const std = @import("std");
const meta = std.meta;
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

pub const ColorRGB = struct {
    r: u8,
    g: u8,
    b: u8,

    const Self = @This();

    pub fn eql(self: Self, other: Self) bool {
        return meta.eql(self, other);
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
        return meta.eql(self, other);
    }
};

pub const FontStyle = struct {
    bold: bool,
    dim: bool,
    italic: bool,
    underline: bool,
    slowblink: bool,
    rapidblink: bool,
    reverse: bool,
    hidden: bool,
    crossedout: bool,
    fraktur: bool,
    overline: bool,

    const Self = @This();

    pub const default = Self{
        .bold = false,
        .dim = false,
        .italic = false,
        .underline = false,
        .slowblink = false,
        .rapidblink = false,
        .reverse = false,
        .hidden = false,
        .crossedout = false,
        .fraktur = false,
        .overline = false,
    };

    pub const bold = Self{
        .bold = true,
        .dim = false,
        .italic = false,
        .underline = false,
        .slowblink = false,
        .rapidblink = false,
        .reverse = false,
        .hidden = false,
        .crossedout = false,
        .fraktur = false,
        .overline = false,
    };

    pub const dim = Self{
        .bold = false,
        .dim = true,
        .italic = false,
        .underline = false,
        .slowblink = false,
        .rapidblink = false,
        .reverse = false,
        .hidden = false,
        .crossedout = false,
        .fraktur = false,
        .overline = false,
    };

    pub const italic = Self{
        .bold = false,
        .dim = false,
        .italic = true,
        .underline = false,
        .slowblink = false,
        .rapidblink = false,
        .reverse = false,
        .hidden = false,
        .crossedout = false,
        .fraktur = false,
        .overline = false,
    };

    pub const underline = Self{
        .bold = false,
        .dim = false,
        .italic = false,
        .underline = true,
        .slowblink = false,
        .rapidblink = false,
        .reverse = false,
        .hidden = false,
        .crossedout = false,
        .fraktur = false,
        .overline = false,
    };

    pub const slowblink = Self{
        .bold = false,
        .dim = false,
        .italic = false,
        .underline = false,
        .slowblink = true,
        .rapidblink = false,
        .reverse = false,
        .hidden = false,
        .crossedout = false,
        .fraktur = false,
        .overline = false,
    };

    pub const rapidblink = Self{
        .bold = false,
        .dim = false,
        .italic = false,
        .underline = false,
        .slowblink = false,
        .rapidblink = true,
        .reverse = false,
        .hidden = false,
        .crossedout = false,
        .fraktur = false,
        .overline = false,
    };

    pub const reverse = Self{
        .bold = false,
        .dim = false,
        .italic = false,
        .underline = false,
        .slowblink = false,
        .rapidblink = false,
        .reverse = true,
        .hidden = false,
        .crossedout = false,
        .fraktur = false,
        .overline = false,
    };

    pub const hidden = Self{
        .bold = false,
        .dim = false,
        .italic = false,
        .underline = false,
        .slowblink = false,
        .rapidblink = false,
        .reverse = false,
        .hidden = true,
        .crossedout = false,
        .fraktur = false,
        .overline = false,
    };

    pub const crossedout = Self{
        .bold = false,
        .dim = false,
        .italic = false,
        .underline = false,
        .slowblink = false,
        .rapidblink = false,
        .reverse = false,
        .hidden = false,
        .crossedout = true,
        .fraktur = false,
        .overline = false,
    };

    pub const fraktur = Self{
        .bold = false,
        .dim = false,
        .italic = false,
        .underline = false,
        .slowblink = false,
        .rapidblink = false,
        .reverse = false,
        .hidden = false,
        .crossedout = false,
        .fraktur = true,
        .overline = false,
    };

    pub const overline = Self{
        .bold = false,
        .dim = false,
        .italic = false,
        .underline = false,
        .slowblink = false,
        .rapidblink = false,
        .reverse = false,
        .hidden = false,
        .crossedout = false,
        .fraktur = false,
        .overline = true,
    };

    pub fn isDefault(self: Self) bool {
        return meta.eql(self, default);
    }

    pub fn eql(self: Self, other: Self) bool {
        return meta.eql(self, other);
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
        return meta.eql(self, other);
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

    expect(a.isDefault());

    expect(a.eql(a));
    expect(b.eql(b));
    expect(c.eql(c));

    expect(!a.eql(b));
    expect(!b.eql(a));
    expect(!a.eql(c));
}
