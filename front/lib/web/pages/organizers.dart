import 'package:flutter/material.dart';
import 'package:mobile/web/ui/appbar.dart';

class OrganizerPage extends StatelessWidget {
  const OrganizerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: const Center(
        child: Text('Welcome to Organizer Page'),
      ),
    );
  }
}
