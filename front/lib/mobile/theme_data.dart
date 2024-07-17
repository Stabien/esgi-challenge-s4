import 'package:flutter/material.dart';

const ColorScheme colorScheme = ColorScheme(
  primary: Color(0xFF1E1E1E),
  secondary: Color(0xFFFFA726),
  // background: Color(0xFF121212),
  surface: Color(0xFF1E1E1E),
  // onBackground: Color(0xFFE0E0E0),
  error: Color(0xFFD32F2F),
  onError: Colors.white,
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.white,
  brightness: Brightness.dark,
);

final ThemeData easyTheme = ThemeData(
  hintColor: Colors.white54,
  canvasColor: Colors.black,
  // scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: colorScheme.onSecondary,
      backgroundColor: colorScheme.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: colorScheme.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: colorScheme.onSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    focusColor: Colors.white,
    labelStyle: TextStyle(color: Colors.white),
    hintStyle: TextStyle(color: Colors.white54),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white54),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  ),
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 24,
      color: Colors.white,
    ),
  ),
);
