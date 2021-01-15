import 'dart:math' as math;
import 'dart:ui' show Color;

mixin ColorHelper {
  /// Converts an RGB color value to HSL. Conversion formula
  /// adapted from http://en.wikipedia.org/wiki/HSL_color_space.
  /// Assumes r, g, and b are contained in the set [0, 255] and
  /// returns h, s, and l in the set [0, 1].
  ///
  /// [int]  red       The red color value
  /// [int]  green       The green color value
  /// [int]  blue       The blue color value
  /// return  [List<double>]           The HSL representation
  static List<double> rgbToHsl(int red, int green, int blue) {
    final r = red / 255, g = green / 255, b = blue / 255;

    double max = math.max(r, math.max(g, b)), min = math.min(r, math.min(g, b));
    double h, s, l = (max + min) / 2;

    if (max == min) {
      h = s = 0; // achromatic
    } else {
      double d = max - min;
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

      if (max == r)
        h = (g - b) / d + (g < b ? 6 : 0);
      else if (max == g)
        h = (b - r) / d + 2;
      else if (max == b) h = (r - g) / d + 4;
      h /= 6;
    }

    return [h, s, l];
  }

  /// Converts an HSL color value to RGB. Conversion formula
  /// adapted from http://en.wikipedia.org/wiki/HSL_color_space.
  /// Assumes h, s, and l are contained in the set [0, 1] and
  /// returns r, g, and b in the set [0, 255].
  ///
  /// [double]  h       The hue
  /// [double]  s       The saturation
  /// [double]  l       The lightness
  /// return  [List<int>]           The RGB representation
  static List<int> hslToRgb(double h, double s, double l) {
    double r, g, b;

    if (s == 0) {
      r = g = b = l; // achromatic
    } else {
      hue2rgb(p, q, t) {
        if (t < 0) t += 1;
        if (t > 1) t -= 1;
        if (t < 1 / 6) return p + (q - p) * 6 * t;
        if (t < 1 / 2) return q;
        if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
        return p;
      }

      double q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      double p = 2 * l - q;

      r = hue2rgb(p, q, h + 1 / 3);
      g = hue2rgb(p, q, h);
      b = hue2rgb(p, q, h - 1 / 3);
    }

    return [(r * 255).toInt(), (g * 255).toInt(), (b * 255).toInt()];
  }

  /// Converts an RGB color value to HSV. Conversion formula
  /// adapted from http://en.wikipedia.org/wiki/HSV_color_space.
  /// Assumes r, g, and b are contained in the set [0, 255] and
  /// returns h, s, and v in the set [0, 1].
  ///
  /// [int]  r       The red color value
  /// [int]  g       The green color value
  /// [int]  b       The blue color value
  /// return  [List<double>]           The HSV representation
  static List<double> rgbToHsv(int red, int green, int blue) {
    final r = red / 255, g = green / 255, b = blue / 255;

    double max = math.max(r, math.max(g, b)), min = math.min(r, math.min(g, b));
    double h, s, v = max;

    double d = max - min;
    s = max == 0 ? 0 : d / max;

    if (max == min) {
      h = 0; // achromatic
    } else {
      if (max == r)
        h = (g - b) / d + (g < b ? 6 : 0);
      else if (max == g)
        h = (b - r) / d + 2;
      else if (max == b) h = (r - g) / d + 4;
      h /= 6;
    }

    return [h, s, v];
  }

  /// Converts an HSV color value to RGB. Conversion formula
  /// adapted from http://en.wikipedia.org/wiki/HSV_color_space.
  /// Assumes h, s, and v are contained in the set [0, 1] and
  /// returns r, g, and b in the set [0, 255].
  ///
  /// [double]  h       The hue
  /// [double]  s       The saturation
  /// [double]  v       The value
  /// return  [List<int>]           The RGB representation
  static List<int> hsvToRgb(double h, double s, double v) {
    double r, g, b;

    int i = (h * 6).toInt();
    double f = h * 6 - i;
    double p = v * (1 - s);
    double q = v * (1 - f * s);
    double t = v * (1 - (1 - f) * s);

    switch (i % 6) {
      case 0:
        r = v;
        g = t;
        b = p;
        break;
      case 1:
        r = q;
        g = v;
        b = p;
        break;
      case 2:
        r = p;
        g = v;
        b = t;
        break;
      case 3:
        r = p;
        g = q;
        b = v;
        break;
      case 4:
        r = t;
        g = p;
        b = v;
        break;
      case 5:
        r = v;
        g = p;
        b = q;
        break;
    }

    return [(r * 255).toInt(), (g * 255).toInt(), (b * 255).toInt()];
  }

  /// Parse a String hexadecimal color to flutter color
  static Color hex2Color(String str) {
    str ??= "";
    if (RegExp(r"[0-9a-fA-F]+").stringMatch(str)?.length != str.length &&
        str.length != 3 &&
        str.length != 6 &&
        str.length != 8) return null;
    int value;
    if (str.length == 3)
      value = int.tryParse("ff${str[0] * 2}${str[1] * 2}${str[2] * 2}", radix: 16);
    else if (str.length == 6)
      value = int.tryParse("ff$str", radix: 16);
    else if (str.length == 8)
      value = int.tryParse(str, radix: 16);
    else
      return null;
    return value == null ? null : Color(value);
  }
}
