import 'package:flutter/material.dart';

class ThemeSearchbar {
  ThemeSearchbar({required this.context});
  final BuildContext context;
  late ThemeData theme = Theme.of(context);

  SearchBarThemeData get searchBarTheme => SearchBarThemeData(
    backgroundColor: WidgetStateProperty.all(
      theme.colorScheme.surfaceContainerLow,
    ),
  );
}
