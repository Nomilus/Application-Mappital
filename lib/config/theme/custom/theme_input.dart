import 'package:flutter/material.dart';

class ThemeInput {
  ThemeInput({required this.context});

  final BuildContext context;
  late ThemeData theme = Theme.of(context);

  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: theme.colorScheme.secondary, width: 1),
    ),
    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: theme.colorScheme.primary, width: 1),
    ),
    hintStyle: theme.textTheme.bodyMedium!.apply(
      color: theme.colorScheme.secondary,
    ),
  );
}
