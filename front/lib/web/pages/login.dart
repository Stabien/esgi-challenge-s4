import 'package:flutter/material.dart';
import 'package:mobile/mobile/utils/trad_token.dart';
import 'package:mobile/web/services/auth_service.dart';
import 'package:mobile/mobile/utils/secure_storage.dart';
import 'package:mobile/mobile/services/user_services.dart';
import 'package:mobile/mobile/models/user.dart';
import 'package:dio/dio.dart';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String jwtSecret = '${dotenv.env['JWT_SECRET']}';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final UserServices _userServices = UserServices();
  String _email = '';
  String _password = '';

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
    final Response response = await _userServices.auth(userCredentials);

    if (response.data['token'] == null) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content: const Text('Erreur d\'authentification.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final jwt = JWT.verify(response.data['token'], SecretKey(jwtSecret));
    final role = jwt.payload['role'];
    if (role != 'admin') {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur'),
            content:
                const Text('Vous n\'avez pas les droits d\'administrateur.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    await SecureStorage.addStorageItem('token', response.data['token']);
    await verifyAndDecodeJwt(response.data['token']);
    AuthService().login();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
