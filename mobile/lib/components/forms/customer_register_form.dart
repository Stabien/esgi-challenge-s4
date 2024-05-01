import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/userServices.dart';

class CustomerRegisterForm extends StatefulWidget {
  const CustomerRegisterForm({super.key});

  @override
  State<CustomerRegisterForm> createState() => _CustomerRegisterFormState();
}

class _CustomerRegisterFormState extends State<CustomerRegisterForm> {
  final UserServices _userServices = UserServices();

  String _email = "";
  String _password = "";
  String _firstname = "";
  String _lastname = "";

  void _onEmailInputChange(String value) {
    setState(() {
      _email = value;
    });
  }

  void _onPasswordInputChange(String value) {
    setState(() {
      _password = value;
    });
  }

  void _onFirstnameInputChange(String value) {
    setState(() {
      _firstname = value;
    });
  }

  void _onLastnameInputChange(String value) {
    setState(() {
      _lastname = value;
    });
  }

  void _onSubmit() async {
    final userCredentials = UserRegistrationPayload(
      _email,
      _password,
      _firstname,
      _lastname,
    );

    final Response response = await _userServices.registerCustomer(
      userCredentials,
    );
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            onChanged: _onLastnameInputChange,
            decoration: const InputDecoration(
              labelText: 'Nom',
            ),
          ),
          TextFormField(
            onChanged: _onFirstnameInputChange,
            decoration: const InputDecoration(
              labelText: 'Prénom',
            ),
          ),
          TextFormField(
            onChanged: _onEmailInputChange,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextFormField(
            onChanged: _onPasswordInputChange,
            decoration: const InputDecoration(
              labelText: 'Mot de passe',
            ),
          ),
          TextButton(
            onPressed: _onSubmit,
            child: const Text("Envoyer"),
          ),
        ],
      ),
    );
  }
}
