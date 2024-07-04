import 'package:flutter/material.dart';
import 'package:mobile/api/firebase_api.dart';
import 'package:mobile/events/create_event_form.dart';
import 'package:mobile/events/join_event.dart';
import 'package:mobile/events/update_event_form.dart';
import 'package:mobile/map/map.dart';
import 'package:mobile/screens/customer_register_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/organizer_register_screen.dart';
import 'package:mobile/screens/forgot_password_screen.dart';
import 'package:mobile/theme_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/layout.dart';
import 'package:mobile/eventDetail/detail_screen.dart';
import 'package:mobile/events/screen_events.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/usersScreen/edit_profil_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await dotenv.load(fileName: ".env.local");
  runApp(const MyApp());

  if (dotenv.env['FIREBASE_API_KEY'] != "default" &&
      dotenv.env['FIREBASE_API_KEY'] != null) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseApi().initNotifications();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: easyTheme,
      themeMode: ThemeMode.dark,
      routes: {
        '/': (context) => const Layout(),
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        switch (settings.name) {
          case '/auth':
            return MaterialPageRoute(
              builder: (context) {
                return const LoginScreen();
              },
            );
          case '/register/customer':
            return MaterialPageRoute(
              builder: (context) {
                return const CustomerRegisterScreen();
              },
            );
          case '/register/organizer':
            return MaterialPageRoute(
              builder: (context) {
                return const OrganizerRegisterScreen();
              },
            );
          case '/forgot-password':
            return MaterialPageRoute(
              builder: (context) {
                return const ForgotPasswordScreen();
              },
            );
          case '/event':
            return MaterialPageRoute(
              builder: (context) {
                return const ScreenEvent();
              },
            );
          case '/event/detail':
            return MaterialPageRoute(
              builder: (context) {
                return DetailScreen(id: args as String);
              },
            );
          case '/event/update':
            return MaterialPageRoute(
              builder: (context) {
                return UpdateEventForm(eventId: args as String);
              },
            );
          case '/event/create':
            return MaterialPageRoute(
              builder: (context) {
                return const CreateEventForm();
              },
            );
          case '/event/join':
            return MaterialPageRoute(
              builder: (context) {
                return const JoinEvent();
              },
            );
          case '/event/map':
            return MaterialPageRoute(
              builder: (context) {
                return EventMap(
                    lat: (args as List)[0] as double, lng: (args)[1] as double);
              },
            );
        }
        return null;
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
    );
  }
}
