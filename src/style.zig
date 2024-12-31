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
    Default,
    Black,
    Red,
    Green,
    Yellow,
    Blue,
    Magenta,
    Cyan,
    White,
    Fixed: u8,
    Grey: u8,
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
        return @bitCast(self);
    }

    pub fn fromU11(bits: u11) Self {
        return @bitCast(bits);
    }

    /// Returns true iff this font style contains no attributes
    pub fn isDefault(self: Self) bool {
        return self.toU11() == 0;
    }

    /// Returns true iff these font styles contain exactly the same
    /// attributes
    pub fn eql(self: Self, other: Self) bool {
        return self.toU11() == other.toU11();
    }

    /// Returns true iff self is a subset of the attributes of
    /// other, i.e. all attributes of self are at least present in
    /// other as well
    pub fn subsetOf(self: Self, other: Self) bool {
        return self.toU11() & other.toU11() == self.toU11();
    }

    /// Returns this font style with all attributes removed that are
    /// contained in other
    pub fn without(self: Self, other: Self) Self {
        return fromU11(self.toU11() & ~other.toU11());
    }
};

test "FontStyle bits" {
    try expectEqual(@as(u11, 0), (FontStyle{}).toU11());
    try expectEqual(@as(u11, 1), (FontStyle{ .bold = true }).toU11());
    try expectEqual(@as(u11, 1 << 2), (FontStyle{ .italic = true }).toU11());
    try expectEqual(@as(u11, 1 << 2) | 1, (FontStyle{ .bold = true, .italic = true }).toU11());
    try expectEqual(FontStyle{}, FontStyle.fromU11((FontStyle{}).toU11()));
    try expectEqual(FontStyle{ .bold = true }, FontStyle.fromU11((FontStyle{ .bold = true }).toU11()));
}

test "FontStyle subsetOf" {
    const default = FontStyle{};
    const bold = FontStyle{ .bold = true };
    const italic = FontStyle{ .italic = true };
    const bold_and_italic = FontStyle{ .bold = true, .italic = true };

    try expect(default.subsetOf(default));
    try expect(default.subsetOf(bold));
    try expect(bold.subsetOf(bold));
    try expect(!bold.subsetOf(default));
    try expect(!bold.subsetOf(italic));
    try expect(default.subsetOf(bold_and_italic));
    try expect(bold.subsetOf(bold_and_italic));
    try expect(italic.subsetOf(bold_and_italic));
    try expect(bold_and_italic.subsetOf(bold_and_italic));
    try expect(!bold_and_italic.subsetOf(bold));
    try expect(!bold_and_italic.subsetOf(italic));
    try expect(!bold_and_italic.subsetOf(default));
}

test "FontStyle without" {
    const default = FontStyle{};
    const bold = FontStyle{ .bold = true };
    const italic = FontStyle{ .italic = true };
    const bold_and_italic = FontStyle{ .bold = true, .italic = true };

    try expectEqual(default, default.without(default));
    try expectEqual(bold, bold.without(default));
    try expectEqual(default, bold.without(bold));
    try expectEqual(bold, bold.without(italic));
    try expectEqual(bold, bold_and_italic.without(italic));
    try expectEqual(italic, bold_and_italic.without(bold));
    try expectEqual(default, bold_and_italic.without(bold_and_italic));
}

pub const Style = struct {
    foreground: Color = .Default,
    background: Color = .Default,
    font_style: FontStyle = FontStyle{},

    const Self = @This();

    /// Returns true iff this style equals the other style in
    /// foreground color, background color and font style
    pub fn eql(self: Self, other: Self) bool {
        if (!self.font_style.eql(other.font_style))
            return false;

        if (!meta.eql(self.foreground, other.foreground))
            return false;

        return meta.eql(self.background, other.background);
    }

    /// Returns true iff this style equals the default set of styles
    pub fn isDefault(self: Self) bool {
        return eql(self, Self{});
    }

    pub const parse = @import("parse_style.zig").parseStyle;
};

test "style equality" {
    const a = Style{};
    const b = Style{
        .font_style = .{ .bold = true },
    };
    const c = Style{
        .foreground = .Red,
    };

    try expect(a.isDefault());

    try expect(a.eql(a));
    try expect(b.eql(b));
    try expect(c.eql(c));

    try expect(!a.eql(b));
    try expect(!b.eql(a));
    try expect(!a.eql(c));
}
