import 'package:flutter/material.dart';
import 'package:mobile/components/forms/login_form.dart';
import 'package:mobile/utils/navigation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LoginForm(),
              TextButton(
                onPressed: () => redirectToPath(context, '/register/customer'),
                child: const Text(
                  "S'inscrire",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
