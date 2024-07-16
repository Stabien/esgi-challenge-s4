import 'package:flutter/material.dart';
import 'package:mobile/mobile/utils/secureStorage.dart';
import 'package:mobile/web/services/auth_service.dart';
import 'package:mobile/web/ui/appbar.dart';

class CheckAuthPage extends StatefulWidget {
  const CheckAuthPage({super.key});

  @override
  CheckAuthPageState createState() => CheckAuthPageState();
}

class CheckAuthPageState extends State<CheckAuthPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final token = await SecureStorage.getStorageItem('token');
    if (token != null && await AuthService().verifyAndDecodeJwt(token)) {
      AuthService().login();
      Navigator.of(context).pushReplacementNamed('/events');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
