import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/mobile/models/user.dart';
import 'package:mobile/mobile/services/user_services.dart';
import 'package:mobile/mobile/utils/navigation.dart';
import 'package:mobile/mobile/utils/secure_storage.dart';
import 'package:mobile/mobile/utils/trad_token.dart';

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

  void _onSubmit(BuildContext context) async {
    final userCredentials = UserCredentials(_email, _password);

    try {
      if (userCredentials.email.isEmpty || userCredentials.password.isEmpty) {
        return;
      }
      final Response response = await _userServices.auth(userCredentials);

      if (response.data['token'] == null) {
        return;
      }

      await SecureStorage.addStorageItem('token', response.data['token']);
      await verifyAndDecodeJwt(response.data['token']);

      // ignore: use_build_context_synchronously
      redirectToPath(context, '/');
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Echec"),
          content: const Text("Utilisateur non trouvé"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
                redirectToPath(context, '/');
              },
            ),
          ],
        ),
      );
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
            onChanged: _onEmailInputChange,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onChanged: _onPasswordInputChange,
            obscureText: true,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleMedium!.color,
            ),
            decoration: const InputDecoration(
              labelText: 'Mot de passe',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => _onSubmit(context),
            child: const Text("Envoyer"),
          ),
        ],
      ),
    );
  }
}
