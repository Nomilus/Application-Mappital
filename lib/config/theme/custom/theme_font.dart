import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeFont {
  ThemeFont({required this.context});

  final BuildContext context;

  TextTheme get textTheme => TextTheme(
    displayLarge: _textStyle(96, FontWeight.bold),
    displayMedium: _textStyle(60, FontWeight.bold),
    displaySmall: _textStyle(48, FontWeight.bold),
    headlineLarge: _textStyle(26, FontWeight.bold),
    headlineMedium: _textStyle(24, FontWeight.bold),
    headlineSmall: _textStyle(22, FontWeight.bold),
    titleLarge: _textStyle(20, FontWeight.bold),
    titleMedium: _textStyle(16, FontWeight.bold),
    titleSmall: _textStyle(14, FontWeight.bold),
    bodyLarge: _textStyle(16, FontWeight.normal),
    bodyMedium: _textStyle(14, FontWeight.normal),
    bodySmall: _textStyle(12, FontWeight.normal),
    labelLarge: _textStyle(14, FontWeight.normal),
    labelMedium: _textStyle(12, FontWeight.normal),
    labelSmall: _textStyle(10, FontWeight.normal),
  );

  TextStyle _textStyle(double fontSize, FontWeight fontWeight) {
    return GoogleFonts.kanit(fontSize: fontSize, fontWeight: fontWeight);
  }
}
