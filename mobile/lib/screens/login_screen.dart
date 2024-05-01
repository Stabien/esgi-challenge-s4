import 'package:flutter/material.dart';
import 'package:mobile/components/forms/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: LoginForm(),
      ),
    );
  }
}
