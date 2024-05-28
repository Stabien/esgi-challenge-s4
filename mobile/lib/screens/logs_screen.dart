// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  final String baseUrl = dotenv.env['URL_BACK'].toString();
  final Dio dio = Dio();

  void fetchLogs() async {
    final Response response = await dio.get('$baseUrl/logs');

    if (response.statusCode == 200) {
      setState(() {
        var data = response.data.toString();
        logs = data.substring(1, data.length - 1).split(',');
      });
    } else {
      print('Failed to load logs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
      ),
      body: FractionallySizedBox(
        widthFactor: 0.8,
        child: ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                logs[index],
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.white70,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
