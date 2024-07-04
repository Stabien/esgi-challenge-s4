import 'package:flutter/material.dart';

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebAppPage(),
    );
  }
}

class WebAppPage extends StatelessWidget {
  const WebAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
      ),
      body: const Center(
        child: Text('Welcome to the Admin App'),
      ),
    );
  }
}
