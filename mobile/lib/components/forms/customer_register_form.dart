import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/userServices.dart';
import 'package:mobile/utils/navigation.dart';
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

    if (response.statusCode == 201) {
      redirectToPath(context, '/auth');
    }
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
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
            decoration: InputDecoration(
              labelText: t(context)!.lastname,
              labelStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              ),
            ),
          ),
          TextFormField(
            onChanged: _onFirstnameInputChange,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
            decoration: InputDecoration(
              labelText: t(context)!.firstname,
              labelStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              ),
            ),
          ),
          TextFormField(
            onChanged: _onEmailInputChange,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
            decoration: InputDecoration(
              labelText: t(context)!.email,
              labelStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              ),
            ),
          ),
          TextFormField(
            onChanged: _onPasswordInputChange,
            obscureText: true,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
            decoration: InputDecoration(
              labelText: t(context)!.password,
              labelStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextButton(
            onPressed: _onSubmit,
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white, // Couleur de fond du bouton
              padding: const EdgeInsets.all(
                8.0,
              ), // Padding autour du texte du bouton
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12.0), // Border radius du bouton
              ),
            ),
            child: Text(
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              ),
              t(context)!.register,
            ),
          ),
        ],
      ),
    );
  }
}
