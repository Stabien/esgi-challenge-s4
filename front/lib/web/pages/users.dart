import 'package:flutter/material.dart';
import 'package:mobile/web/ui/appbar.dart';

class WebUserPage extends StatelessWidget {
  const WebUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: const Center(
        child: Text('Welcome to the USER PAGE'),
      ),
    );
  }
}
