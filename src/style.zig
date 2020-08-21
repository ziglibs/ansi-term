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

pub const FontStyle = packed struct {
    bold: bool = false,
    dim: bool = false,
    italic: bool = false,
    underline: bool = false,
    slowblink: bool = false,
    rapidblink: bool = false,
    reverse: bool = false,
    hidden: bool = false,
    crossedout: bool = false,
    fraktur: bool = false,
    overline: bool = false,

    const Self = @This();

    pub fn toU11(self: Self) u11 {
        return @bitCast(u11, self);
    }

    pub fn fromU11(bits: u11) Self {
        return @bitCast(Self, bits);
    }

    pub const bold = Self{
        .bold = true,
    };

    pub const dim = Self{
        .dim = true,
    };

    pub const italic = Self{
        .italic = true,
    };

    pub const underline = Self{
        .underline = true,
    };

    pub const slowblink = Self{
        .slowblink = true,
    };

    pub const rapidblink = Self{
        .rapidblink = true,
    };

    pub const reverse = Self{
        .reverse = true,
    };

    pub const hidden = Self{
        .hidden = true,
    };

    pub const crossedout = Self{
        .crossedout = true,
    };

    pub const fraktur = Self{
        .fraktur = true,
    };

    pub const overline = Self{
        .overline = true,
    };

    pub fn isDefault(self: Self) bool {
        return self.toU11() == 0;
    }

    pub fn eql(self: Self, other: Self) bool {
        return self.toU11() == other.toU11();
    }
};

test "FontStyle bits" {
    expectEqual(@as(u11, 0), (FontStyle{}).toU11());
    expectEqual(@as(u11, 1), (FontStyle.bold).toU11());
    expectEqual(@as(u11, 1 << 2), (FontStyle.italic).toU11());
    expectEqual(@as(u11, 1 << 2) | 1, (FontStyle{ .bold = true, .italic = true }).toU11());
    expectEqual(FontStyle{}, FontStyle.fromU11((FontStyle{}).toU11()));
    expectEqual(FontStyle.bold, FontStyle.fromU11((FontStyle.bold).toU11()));
}

pub const Style = struct {
    foreground: ?Color = null,
    background: ?Color = null,
    font_style: FontStyle = FontStyle{},

    const Self = @This();

    pub fn eql(self: Self, other: Self) bool {
        return meta.eql(self, other);
    }

    pub fn isDefault(self: Self) bool {
        return meta.eql(self, Self{});
    }
};

test "style equality" {
    const a = Style{};
    const b = Style{
        .font_style = FontStyle.bold,
    };
    const c = Style{
        .foreground = Color.Red,
    };

    expect(a.isDefault());

    expect(a.eql(a));
    expect(b.eql(b));
    expect(c.eql(c));

    expect(!a.eql(b));
    expect(!b.eql(a));
    expect(!a.eql(c));
}
