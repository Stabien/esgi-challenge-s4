import 'package:flutter/material.dart';


const ColorScheme colorScheme = ColorScheme(
  primary: Color(0xFFAF06FF),
  secondary: Color(0xFFFF9900),
  background: Color(0xFF272727),
  surface: Color(0xFFFFF503),
  onBackground: Color(0xFFE9ECF1),
  error: Color(0xFFFF765F),
  onError: Colors.greenAccent,
  onPrimary: Colors.redAccent,
  onSecondary: Colors.blueAccent,
  onSurface: Colors.black38,
  brightness: Brightness.dark,
);

final ThemeData easyTheme = ThemeData(
  fontFamily: 'MonumentExtended',
  hintColor: Colors.green,
  canvasColor: Colors.blue,
  scaffoldBackgroundColor: Colors.green,
  primarySwatch: Colors.red,
  colorScheme: colorScheme,
    textTheme:TextTheme(

      bodyLarge: TextStyle( fontSize: 25,
          color: Colors.red,
          fontFamily: 'MonumentExtended'),
        bodyMedium: TextStyle(

            fontSize: 25,
            color: Colors.blue,
            fontFamily: 'MonumentExtended'
        ),
      titleLarge: TextStyle(
        fontFamily: 'Grotesk',
        fontSize: 25,
        color: Colors.green,
      ),

    )
);