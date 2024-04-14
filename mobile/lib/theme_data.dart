import 'package:flutter/material.dart';

final ThemeData easyTheme = ThemeData(
  hintColor: Colors.green,
  canvasColor: Colors.blue,
  scaffoldBackgroundColor: Colors.green,
  primarySwatch: Colors.red,
  colorScheme: const ColorScheme(
    primary: Color(0xFFFF8383),
    secondary: Color(0xFF4D1F7C),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF),
    error: Colors.redAccent,
    onError: Colors.greenAccent,
    onPrimary: Colors.redAccent,
    onSecondary: Colors.blueAccent,
    onSurface: Colors.black38,
    brightness: Brightness.dark,
  ),
    textTheme:const TextTheme(
        bodyMedium: TextStyle(
            fontSize: 25
        )
    )
);