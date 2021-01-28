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

    pub fn toU11(self: Self) u11 {
        return @bitCast(u11, self);
    }

    pub fn fromU11(bits: u11) Self {
        return @bitCast(Self, bits);
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
    expectEqual(@as(u11, 0), (FontStyle{}).toU11());
    expectEqual(@as(u11, 1), (FontStyle.bold).toU11());
    expectEqual(@as(u11, 1 << 2), (FontStyle.italic).toU11());
    expectEqual(@as(u11, 1 << 2) | 1, (FontStyle{ .bold = true, .italic = true }).toU11());
    expectEqual(FontStyle{}, FontStyle.fromU11((FontStyle{}).toU11()));
    expectEqual(FontStyle.bold, FontStyle.fromU11((FontStyle.bold).toU11()));
}

test "FontStyle subsetOf" {
    const default = FontStyle{};
    const bold = FontStyle.bold;
    const italic = FontStyle.italic;
    const bold_and_italic = FontStyle{ .bold = true, .italic = true };

    expect(default.subsetOf(default));
    expect(default.subsetOf(bold));
    expect(bold.subsetOf(bold));
    expect(!bold.subsetOf(default));
    expect(!bold.subsetOf(italic));
    expect(default.subsetOf(bold_and_italic));
    expect(bold.subsetOf(bold_and_italic));
    expect(italic.subsetOf(bold_and_italic));
    expect(bold_and_italic.subsetOf(bold_and_italic));
    expect(!bold_and_italic.subsetOf(bold));
    expect(!bold_and_italic.subsetOf(italic));
    expect(!bold_and_italic.subsetOf(default));
}

test "FontStyle without" {
    const default = FontStyle{};
    const bold = FontStyle.bold;
    const italic = FontStyle.italic;
    const bold_and_italic = FontStyle{ .bold = true, .italic = true };

    expectEqual(default, default.without(default));
    expectEqual(bold, bold.without(default));
    expectEqual(default, bold.without(bold));
    expectEqual(bold, bold.without(italic));
    expectEqual(bold, bold_and_italic.without(italic));
    expectEqual(italic, bold_and_italic.without(bold));
    expectEqual(default, bold_and_italic.without(bold_and_italic));
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
