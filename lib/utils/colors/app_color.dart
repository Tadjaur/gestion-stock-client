import 'package:flutter/material.dart';

import 'color_helper.dart';

mixin getAppColors {
  static final secondary = AppColor(Color(0xFF32A5B6));
  static final primary = AppColor(Color(0xFFAF564E));
  static final accent = AppColor(Color(0xFFF5B97A));
}

/// class that bring more future to the class [MaterialColor]
class AppColor extends MaterialColor {
  final _CustomColor _backGenerator;
  final Color lightness, darkness;

  factory AppColor(Color color) {
    final _temp = _CustomColor(color);
    return AppColor._(_temp, _temp.material.value, _temp.swatch);
  }

  Color reverseBrightness({Color target, Brightness brightness}) {
    _CustomColor sColor, dColor;
    sColor = this._backGenerator;
    if (target == null)
      dColor = sColor;
    else if (target is AppColor)
      dColor = target._backGenerator;
    else
      dColor = _CustomColor(target);
    final distance = (dColor._luminance - sColor._luminance) * 100;
    final _lightness = sColor._luminance * 1000 > 700
        ? null
        : dColor.rgb((1000 - 300 - (sColor._luminance * 1000).clamp(0, 700)).toInt());
    final _darkness = sColor._luminance * 1000 < 300
        ? null
        : dColor.rgb((1000 + 300 - (sColor._luminance * 1000).clamp(300, 1000)).toInt());
    if (distance.abs() >= 30) {
      if (brightness == Brightness.light && distance.isNegative) return _lightness ?? dColor.color;
      if (brightness == Brightness.dark && !distance.isNegative) return _darkness ?? dColor.color;
      return dColor.color;
    } else {
      if (brightness == Brightness.light) return _lightness ?? _darkness;
      return _darkness ?? _lightness;
    }
  }

  AppColor._(this._backGenerator, int primary, Map<int, Color> swatch)
      : lightness = _backGenerator.rgb(20),
        darkness = _backGenerator.rgb(950),
        super(primary, swatch);
}

class _CustomColor {
  final Color color;
  double _hue, _saturation, _luminance;
  String _key;

  Map<int, Color> _swatch;

  Map<int, Color> get swatch {
    if (_swatch == null) material;
    return _swatch;
  }

  _CustomColor(this.color) {
    final hsl = ColorHelper.rgbToHsl(color.red, color.green, color.blue);
    _hue = hsl[0];
    _saturation = hsl[1];
    _luminance = hsl[2];
    _key = ("$_hue".length < 5 ? "$_hue" : "$_hue".substring(0, 5)) +
        " " +
        ("$_saturation".length < 5 ? "$_saturation" : "$_saturation".substring(0, 5));
  }

  Color rgb(int swatch) {
    final aux = ColorHelper.hslToRgb(_hue, _saturation, (1000 - swatch) / 1000);
    return Color.fromARGB(255, aux[0], aux[1], aux[2]);
  }

  MaterialColor get material {
    _swatch = <int, Color>{
      50: rgb(50),
      100: rgb(100),
      200: rgb(200),
      300: rgb(300),
      400: rgb(400),
      500: rgb(500),
      600: rgb(600),
      700: rgb(700),
      800: rgb(800),
      900: rgb(900),
    };
    return MaterialColor(color.value, swatch);
  }

  @override
  String toString() {
    return _key;
  }
}
