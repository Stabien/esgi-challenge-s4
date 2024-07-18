import 'package:flutter/material.dart';
import 'package:mobile/mobile/events/chat_screen.dart';
import 'package:mobile/mobile/events/create_event_form.dart';
import 'package:mobile/mobile/events/join_event.dart';
import 'package:mobile/mobile/events/update_event_form.dart';
import 'package:mobile/mobile/map/map.dart';
import 'package:mobile/mobile/models/profil.dart';
import 'package:mobile/mobile/screens/customer_register_screen.dart';
import 'package:mobile/mobile/screens/login_screen.dart';
import 'package:mobile/mobile/screens/organizer_register_screen.dart';
import 'package:mobile/mobile/screens/forgot_password_screen.dart';
import 'package:mobile/mobile/theme_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/mobile/layout.dart';
import 'package:mobile/mobile/eventDetail/detail_screen.dart';
import 'package:mobile/mobile/events/screen_events.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile/mobile/usersScreen/edit_profil_screen.dart';
import 'package:mobile/mobile/screens/qr_code_scanner_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await dotenv.load(fileName: ".env.local");

  runApp(const MobileApp());
}

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

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
          case '/event/message':
            return MaterialPageRoute(
              builder: (context) {
                return MessagePage(id: args as String);
              },
            );
          case '/profil/update':
            return MaterialPageRoute(
              builder: (context) {
                return EditProfilePage(userProfile: args as Profil);
              },
            );
          case '/scanner':
            return MaterialPageRoute(
              builder: (context) {
                return const QRCodeScannerScreen();
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
