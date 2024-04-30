import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/services/userServices.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "";
  String _password = "";

  void _onEmailInputChange(String value) {
    setState(() {
      _email = value;
    });
  }

  void _onPasswordInputChange(String value) {
    setState(() {
      _email = value;
    });
  }

  void _onSubmit() async {
    final Response response = await UserServices().auth(_email, _password);

    print(response);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            onChanged: _onEmailInputChange,
          ),
          TextFormField(
            onChanged: _onPasswordInputChange,
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
