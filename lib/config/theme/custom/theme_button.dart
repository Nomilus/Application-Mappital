import 'package:flutter/material.dart';

class ThemeButton {
  ThemeButton({required this.context});

  final BuildContext context;

  ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
