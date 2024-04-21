import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/home_screen.dart';
import 'package:mobile/create_event_form.dart';
import 'package:mobile/update_event_form.dart';

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
    return const MaterialApp(
        home: HomeScreen(),
        // home: UpdateEventForm(
        //   eventId: '244cf171-3aaf-426a-8f34-030941912146',
        // ),
        // home: CreateEventForm(),
        debugShowCheckedModeBanner: false);
  }
}
