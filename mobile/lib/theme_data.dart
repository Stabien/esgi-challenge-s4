import 'package:flutter/material.dart';

const ColorScheme colorScheme = ColorScheme(
  primary: Color(0xFF353535),
  secondary: Color(0xFFFF9900),
  background: Color(0xFF272727),
  surface: Color.fromARGB(255, 255, 255, 255),
  onBackground: Color(0xFFE9ECF1),
  error: Color(0xFFFF765F),
  onError: Colors.greenAccent,
  onPrimary: Colors.black87,
  onSecondary: Colors.black54,
  onSurface: Colors.black87,
  brightness: Brightness.dark,
);

final ThemeData easyTheme = ThemeData(
    fontFamily: 'MonumentExtended',
    hintColor: Colors.green,
    canvasColor: Colors.black,
    scaffoldBackgroundColor: Colors.black87,
    // primarySwatch: const MaterialColor(0xFF00000),
    colorScheme: colorScheme,
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
      hintStyle: TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontFamily: 'MonumentExtended',
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        color: Colors.black87,
        fontFamily: 'MonumentExtended',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
        fontFamily: 'MonumentExtended',
      ),
      titleLarge: TextStyle(
        fontFamily: 'Grotesk',
        fontSize: 24,
        color: Colors.black87,
      ),
    ));
