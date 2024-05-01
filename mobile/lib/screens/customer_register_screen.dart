import 'package:flutter/material.dart';
import 'package:mobile/components/forms/customer_register_form.dart';

class CustomerRegisterScreen extends StatelessWidget {
  const CustomerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: CustomerRegisterForm(),
      ),
    );
  }
}
