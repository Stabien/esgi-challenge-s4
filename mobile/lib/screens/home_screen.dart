import 'package:flutter/material.dart';
import 'package:mobile/components/disconnect-button.dart';
import 'package:mobile/notifications/local_notification.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/notifications/local_notification.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void sendNotification() async {
    await LocalNotifications.initialize();
    // var dio = Dio();
    // dio.options.connectTimeout = const Duration(milliseconds: 10000);
    // String? apiUrl = '${dotenv.env['URL_BACK']}/send-notification';

    // try {
    //   await Future.delayed(Duration(seconds: 2));
    //   var response = await dio.post(apiUrl);
    //   if (response.statusCode == 200) {
    //     print('----------Notification sent successfully----------');
    //   } else {
    //     print(
    //         '----------Failed to send notification: ${response.statusCode}----------');
    //   }
    // } catch (e) {
    //   print('----------Error sending notification: $e----------');
    // }
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
            Directionality(
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
            ElevatedButton.icon(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {
                // add timer to show notification after 5 seconds
                Timer(Duration(seconds: 2), () {
                  LocalNotifications.showSimpleNotification(
                      title: "Simple Notification",
                      body: "This is a simple notification",
                      payload: "This is simple data");
                });
                // LocalNotifications.showSimpleNotification(
                //     title: "Simple Notification",
                //     body: "This is a simple notification",
                //     payload: "This is simple data");
              },
              label: const Text("Simple Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
