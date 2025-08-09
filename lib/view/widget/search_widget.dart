import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded),
          hintText: 'ค้นหา',
          hintStyle: theme.textTheme.bodyMedium,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.surfaceContainerLow,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(100),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.surfaceContainerLow,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.surfaceContainerLow,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.surfaceContainerLow,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.surfaceContainerLow,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
