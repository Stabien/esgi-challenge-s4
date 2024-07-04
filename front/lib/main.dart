import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mobile/mobile/main.dart';
import 'package:mobile/web/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  await dotenv.load(fileName: ".env.local");

  if (kIsWeb) {
    runApp(const WebApp());
  } else {
    runApp(const MobileApp());
  }
}
