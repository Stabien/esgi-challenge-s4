import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/mobile/models/user.dart';
import 'package:mobile/mobile/services/user_services.dart';
import 'package:mobile/mobile/utils/navigation.dart';
import 'package:mobile/mobile/utils/translate.dart';

class OrganizerRegisterForm extends StatefulWidget {
  const OrganizerRegisterForm({super.key});

  @override
  State<OrganizerRegisterForm> createState() => _OrganizerRegisterFormState();
}

class _OrganizerRegisterFormState extends State<OrganizerRegisterForm> {
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

    if (userCredentials.email.isEmpty ||
        userCredentials.password.isEmpty ||
        userCredentials.firstname.isEmpty ||
        userCredentials.lastname.isEmpty) {
      return;
    } else {
      final Response response = await _userServices.registerOrganizer(
        userCredentials,
      );

      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        redirectToPath(context, '/auth');
      }
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
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
            decoration: InputDecoration(
              labelText: t(context)!.lastname,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onChanged: _onFirstnameInputChange,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
            decoration: InputDecoration(
              labelText: t(context)!.firstname,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onChanged: _onEmailInputChange,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
            decoration: InputDecoration(
              labelText: t(context)!.email,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onChanged: _onPasswordInputChange,
            obscureText: true,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
            decoration: InputDecoration(
              labelText: t(context)!.password,
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _onSubmit,
            child: Text(
              t(context)!.send,
            ),
          ),
        ],
      ),
    );
  }
}
