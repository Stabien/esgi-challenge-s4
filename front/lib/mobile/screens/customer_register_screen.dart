import 'package:flutter/material.dart';
import 'package:mobile/mobile/components/forms/customer_register_form.dart';
import 'package:mobile/mobile/utils/navigation.dart';

class CustomerRegisterScreen extends StatelessWidget {
  const CustomerRegisterScreen({super.key});

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
              child: CustomerRegisterForm(),
            ),
            TextButton(
              onPressed: () => redirectToPath(context, '/auth'),
              child: Text(
                'Déjà inscrit ? Connectez-vous !',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleMedium!.color,
                ),
              ),
            ),
            TextButton(
              onPressed: () => redirectToPath(context, '/register/organizer'),
              child: Text(
                "S'inscrire en tant qu'organisateur",
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
