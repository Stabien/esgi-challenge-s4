import 'package:flutter/material.dart';
import 'package:mobile/mobile/components/forms/organizer_register_form.dart';
import 'package:mobile/mobile/utils/navigation.dart';
import 'package:mobile/mobile/utils/translate.dart';

class OrganizerRegisterScreen extends StatelessWidget {
  const OrganizerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            const FractionallySizedBox(
              widthFactor: 0.8,
              child: OrganizerRegisterForm(),
            ),
            TextButton(
              onPressed: () => redirectToPath(context, '/auth'),
              child: Text(
                t(context)!.alreadyRegisteredConnect,
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleMedium!.color,
                ),
              ),
            ),
            TextButton(
              onPressed: () => redirectToPath(context, '/register/customer'),
              child: Text(
                t(context)!.signUpCustomer,
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleMedium!.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
