import 'dart:ui' as ui show Shadow, FontFeature;

import 'package:flutter/material.dart';

AppStyles getAppStyles = AppStyles();

class AppStyles {
  final _CustomTextStyle tsBody2;
  final _CustomTextStyle tsBody1;
  final _CustomTextStyle tsBody;
  final _CustomTextStyle tsHeader3;
  final _CustomTextStyle tsHeader2;
  final _CustomTextStyle tsHeader1;
  final _CustomTextStyle tsHeader;

  AppStyles()
      : this.tsBody = _CustomTextStyle(fontSize: 13, fontWeight: FontWeight.w100),
        this.tsBody1 = _CustomTextStyle(fontSize: 15, fontWeight: FontWeight.w300),
        this.tsBody2 = _CustomTextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        this.tsHeader = _CustomTextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        this.tsHeader1 = _CustomTextStyle(fontSize: 23, fontWeight: FontWeight.w700),
        this.tsHeader2 = _CustomTextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        this.tsHeader3 = _CustomTextStyle(fontSize: 38, fontWeight: FontWeight.w900);
}

class _CustomTextStyle extends TextStyle {
  const _CustomTextStyle(
      {Color color,
      Color backgroundColor,
      Color decorationColor,
      TextDecorationStyle decorationStyle,
      Paint foreground,
      Paint background,
      String fontFamily,
      String debugLabel,
      List<String> fontFamilyFallback,
      double fontSize,
      TextBaseline textBaseline,
      double letterSpacing,
      double wordSpacing,
      double height,
      Locale locale,
      bool inherit = true,
      TextDecoration decoration,
      List<ui.Shadow> shadows,
      List<ui.FontFeature> fontFeatures,
      FontStyle fontStyle,
      double decorationThickness,
      FontWeight fontWeight})
      : super(
          inherit: inherit,
          color: color,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          textBaseline: textBaseline,
          height: height,
          locale: locale,
          foreground: foreground,
          background: background,
          shadows: shadows,
          fontFeatures: fontFeatures,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThickness: decorationThickness,
          debugLabel: debugLabel,
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
        );

  TextStyle withValues(
      {Color color,
      Color backgroundColor,
      Color decorationColor,
      TextDecorationStyle decorationStyle,
      Paint foreground,
      Paint background,
      String fontFamily,
      String debugLabel,
      List<String> fontFamilyFallback,
      double fontSize,
      TextBaseline textBaseline,
      double letterSpacing,
      double wordSpacing,
      double height,
      Locale locale,
      bool inherit,
      TextDecoration decoration,
      List<ui.Shadow> shadows,
      List<ui.FontFeature> fontFeatures,
      FontStyle fontStyle,
      double decorationThickness,
      FontWeight fontWeight}) {
    return TextStyle(
      inherit: inherit ?? this.inherit,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontFamilyFallback: fontFamilyFallback ?? this.fontFamilyFallback,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      wordSpacing: wordSpacing ?? this.wordSpacing,
      textBaseline: textBaseline ?? this.textBaseline,
      height: height ?? this.height,
      locale: locale ?? this.locale,
      foreground: foreground ?? this.foreground,
      background: background ?? this.background,
      shadows: shadows ?? this.shadows,
      fontFeatures: fontFeatures ?? this.fontFeatures,
      decoration: decoration ?? this.decoration,
      decorationColor: decorationColor ?? this.decorationColor,
      decorationStyle: decorationStyle ?? this.decorationStyle,
      decorationThickness: decorationThickness ?? this.decorationThickness,
      debugLabel: debugLabel ?? this.debugLabel,
    );
  }
}
