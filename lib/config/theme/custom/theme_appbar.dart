import 'package:flutter/material.dart';

class ThemeAppBar {
  ThemeAppBar({required this.context});

  final BuildContext context;

  AppBarTheme get appBarTheme => const AppBarTheme(
    // color: Colors.transparent,
    // shadowColor: Colors.transparent,
    // surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 4,
  );
}
