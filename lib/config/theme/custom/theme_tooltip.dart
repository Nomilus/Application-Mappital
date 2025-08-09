import 'package:flutter/material.dart';

class ThemeTooltip {
  ThemeTooltip({required this.context});

  BuildContext context;

  TooltipThemeData get tooltipTheme =>
      TooltipThemeData(textStyle: Theme.of(context).textTheme.bodySmall);
}
