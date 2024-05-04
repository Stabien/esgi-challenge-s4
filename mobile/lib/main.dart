import 'package:flutter/material.dart';
import 'package:mobile/theme_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/layout.dart';

import 'events/screen_events.dart';


void main() async {
  await dotenv.load();
  await dotenv.load(fileName: ".env.local");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: const Layout(),
      home: const ScreenEvent(),
      debugShowCheckedModeBanner: false,
      theme: easyTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
