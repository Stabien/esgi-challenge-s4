import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/userServices.dart';
import 'package:mobile/utils/secureStorage.dart';
import 'package:mobile/utils/tradToken.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final UserServices _userServices = UserServices();

  String _email = "";
  String _password = "";

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

  void _onSubmit() async {
    final userCredentials = UserCredentials(_email, _password);
    final Response response = await _userServices.auth(userCredentials);

    await SecureStorage.addStorageItem('token', response.data['token']);

    await verifyAndDecodeJwt(response.data['token']);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
