import 'package:flutter/material.dart';
import 'package:mobile/mobile/components/disconnect-button.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void sendNotification() async {
    var dio = Dio();
    dio.options.connectTimeout = const Duration(milliseconds: 10000);
    String? apiUrl = '${dotenv.env['URL_BACK']}/send-notification';

    try {
      await Future.delayed(const Duration(seconds: 2));
      var response = await dio.post(apiUrl);
      if (response.statusCode == 200) {
        // print('----------Notification sent successfully----------');
      } else {
        // print(
        //     '----------Failed to send notification: ${response.statusCode}----------');
      }
    } catch (e) {
      // print('----------Error sending notification: $e----------');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          // text center
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Directionality(
              textDirection: TextDirection.ltr,
              child: DisconnectButton(),
              // Text(
              //   "EASY NIGHT",
              //   style: TextStyle(
              //     color: Colors.red,
              //     fontSize: 22,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ),
            ElevatedButton(
              onPressed: sendNotification,
              child: const Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
