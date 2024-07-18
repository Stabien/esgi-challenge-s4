import 'package:flutter/material.dart';
import 'package:mobile/mobile/components/forms/login_form.dart';
import 'package:mobile/mobile/utils/navigation.dart';
import 'package:mobile/mobile/utils/translate.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  "assets/images/iconFlutter.png",
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),
              const LoginForm(),
              TextButton(
                onPressed: () => redirectToPath(context, '/register/customer'),
                child: Text(
                  t(context)!.signup,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium!.color,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => redirectToPath(context, '/forgot-password'),
                child: Text(
                  t(context)!.forgotPassword,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium!.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
