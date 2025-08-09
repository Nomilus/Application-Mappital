import 'package:flutter/material.dart';
import 'package:application_mappital/config/theme/custom/theme_appbar.dart';
import 'package:application_mappital/config/theme/custom/theme_button.dart';
import 'package:application_mappital/config/theme/custom/theme_color.dart';
import 'package:application_mappital/config/theme/custom/theme_font.dart';
import 'package:application_mappital/config/theme/custom/theme_input.dart';
import 'package:application_mappital/config/theme/custom/theme_list.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme({required this.context}) {
    _themeColor = ThemeColor();
    _themeFont = ThemeFont(context: context);
    _themeAppBar = ThemeAppBar(context: context);
    _themeButton = ThemeButton(context: context);
    _themeInput = ThemeInput(context: context);
    _themeList = ThemeList(context: context);
  }

  final BuildContext context;
  late final ThemeColor _themeColor;
  late final ThemeFont _themeFont;
  late final ThemeAppBar _themeAppBar;
  late final ThemeButton _themeButton;
  late final ThemeInput _themeInput;
  late final ThemeList _themeList;

  ThemeData get getLightTheme => _getTheme(Brightness.light);
  ThemeData get getDarkTheme => _getTheme(Brightness.dark);

  ThemeData _getTheme(Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _themeColor.seed,
        error: _themeColor.error,
        brightness: brightness,
        dynamicSchemeVariant: DynamicSchemeVariant.rainbow,
      ),
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontFamilyFallback: [GoogleFonts.kanit().fontFamily!],
      appBarTheme: _themeAppBar.appBarTheme,
      elevatedButtonTheme: _themeButton.elevatedButtonTheme,
      outlinedButtonTheme: _themeButton.outlinedButtonTheme,
      floatingActionButtonTheme: _themeButton.floatingActionButtonTheme,
      textTheme: _themeFont.textTheme,
      inputDecorationTheme: _themeInput.inputDecorationTheme,
      listTileTheme: _themeList.listTileTheme,
      useMaterial3: true,
    );
  }
}
