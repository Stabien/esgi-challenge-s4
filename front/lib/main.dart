import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mobile/mobile/main.dart';
import 'package:mobile/web/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/mobile/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  await dotenv.load();
  await dotenv.load(fileName: ".env.local");

  if (kIsWeb) {
    runApp(const WebApp());
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.instance.requestPermission();
    runApp(const MobileApp());
  }
}
