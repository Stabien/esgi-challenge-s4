import 'package:flutter/material.dart';
import 'package:mobile/components/forms/organizer_register_form.dart';
import 'package:mobile/utils/navigation.dart';

class OrganizerRegisterScreen extends StatelessWidget {
  const OrganizerRegisterScreen({super.key});

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
              child: OrganizerRegisterForm(),
            ),
            TextButton(
              onPressed: () => redirectToPath(context, '/auth'),
              child: const Text(
                'Déjà inscrit ? Connectez-vous !',
              ),
            ),
            TextButton(
              onPressed: () => redirectToPath(context, '/register/customer'),
              child: const Text(
                "S'inscrire en tant qu'utilisateur",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
