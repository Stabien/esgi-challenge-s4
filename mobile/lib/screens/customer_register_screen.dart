import 'package:flutter/material.dart';
import 'package:mobile/components/forms/customer_register_form.dart';
import 'package:mobile/utils/navigation.dart';

class CustomerRegisterScreen extends StatelessWidget {
  const CustomerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FractionallySizedBox(
              widthFactor: 0.8,
              child: CustomerRegisterForm(),
            ),
            TextButton(
              onPressed: () => redirectToPath(context, '/auth'),
              child: const Text(
                'Déjà inscrit ? Connectez-vous !',
              ),
            ),
            TextButton(
              onPressed: () => redirectToPath(context, '/register/organizer'),
              child: const Text(
                "S'inscrire en tant qu'organisateur",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
