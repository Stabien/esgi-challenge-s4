import 'package:flutter/material.dart';
import 'package:mobile/components/forms/organizer_register_form.dart';

class OrganizerRegisterScreen extends StatelessWidget {
  const OrganizerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: OrganizerRegisterForm(),
      ),
    );
  }
}
