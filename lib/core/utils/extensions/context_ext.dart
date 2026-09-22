import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get text => Theme.of(this).textTheme;

  MediaQueryData get media => MediaQuery.of(this);

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  void showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? colors.error : colors.onSurface,
        ),
      );
  }
}