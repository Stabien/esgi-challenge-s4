import 'package:flutter/material.dart';
import 'package:mobile/web/pages/tag.dart';
import 'package:mobile/web/services/auth_service.dart';
import 'package:mobile/web/services/check_auth_page.dart';
import 'package:mobile/web/ui/appbar.dart';
import 'pages/events.dart';
import 'pages/messages.dart';
import 'pages/reservations.dart';
import 'pages/users.dart';
import 'pages/feature_flipping.dart';
import 'pages/logs.dart';
import 'pages/login.dart';

void main() {
  runApp(const WebApp());
}

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/login': (context) => const Login(),
        '/': (context) => const CheckAuthPage(),
        '/users': (context) => const AuthGuard(child: WebUserPage()),
        '/events': (context) => const AuthGuard(child: EventsPage()),
        '/messages': (context) => const AuthGuard(child: MessagesPage()),
        '/reservations': (context) =>
            const AuthGuard(child: ReservationsPage()),
        '/feature_flipping': (context) =>
            const AuthGuard(child: FeatureFlippingPage()),
        '/tags': (context) => const AuthGuard(child: TagPage()),
        '/logs': (context) => const AuthGuard(child: LogsPage()),
      },
    );
  }
}

class WebAppPage extends StatelessWidget {
  const WebAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return Scaffold(
      appBar: authService.isLoggedIn ? const WebAppBar() : null,
      body: Center(
        child:
            authService.isLoggedIn ? const Text('Bienvenue!') : const Login(),
      ),
    );
  }
}

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    if (!authService.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });
      return const SizedBox.shrink();
    }
    return child;
  }
}
