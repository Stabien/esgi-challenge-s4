import 'package:flutter/material.dart';
import 'package:mobile/web/ui/appbar.dart';
import 'pages/events.dart';
import 'pages/messages.dart';
import 'pages/notifications.dart';
import 'pages/organizers.dart';
import 'pages/rates.dart';
import 'pages/reservations.dart';
import 'pages/users.dart';
import 'pages/feature_flipping.dart';
import 'pages/logs.dart';

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
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const WebAppPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/users': (context) => const WebUserPage(),
        '/events': (context) => const EventsPage(),
        '/messages': (context) => const MessagesPage(),
        '/notification': (context) => const NotificationPage(),
        '/organizer': (context) => const OrganizerPage(),
        '/rates': (context) => const RatePage(),
        '/reservations': (context) => const ReservationsPage(),
        '/feature_flipping': (context) => const FeatureFlippingPage(),
        '/logs': (context) => const LogsPage(),
      },
    );
  }
}

class WebAppPage extends StatelessWidget {
  const WebAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/users');
            },
            child: Text('Go to Users Page')),
      ),
    );
  }
}
