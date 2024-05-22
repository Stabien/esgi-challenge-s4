import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/userServices.dart';
import 'package:mobile/utils/translate.dart';

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
            decoration: InputDecoration(
              labelText: t(context)!.lastname,
            ),
          ),
          TextFormField(
            onChanged: _onFirstnameInputChange,
            decoration: InputDecoration(
              labelText: t(context)!.firstname,
            ),
          ),
          TextFormField(
            onChanged: _onEmailInputChange,
            decoration: InputDecoration(
              labelText: t(context)!.email,
            ),
          ),
          TextFormField(
            onChanged: _onPasswordInputChange,
            decoration: InputDecoration(
              labelText: t(context)!.password,
            ),
          ),
          TextButton(
            onPressed: _onSubmit,
            child: Text(
              t(context)!.register,
            ),
          ),
        ],
      ),
    );
  }
}
