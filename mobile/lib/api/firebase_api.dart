import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Create an instance of Firebase Messaging
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final token = await _firebaseMessaging.getToken();

    print('-------------------------------------------');
    print('Token: $token');
    print('-------------------------------------------');
  }
}
