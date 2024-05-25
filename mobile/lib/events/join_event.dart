import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/utils/secureStorage.dart';

class JoinEvent extends StatefulWidget {
  const JoinEvent({super.key});

  @override
  JoinEventState createState() => JoinEventState();
}

class JoinEventState extends State<JoinEvent> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void joinEvent(String code) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String? token = await SecureStorage.getStorageItem('token');

    try {
      var dio = Dio();
      dio.options.connectTimeout = const Duration(milliseconds: 10000);
      String? apiUrl = '${dotenv.env['URL_BACK']}/event/join/$code';

      // add bearer token
      dio.options.headers['Authorization'] = 'Bearer $token';

      var response = await dio.post(apiUrl);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Succès'),
            content: const Text('Vous avez rejoint l\'événement avec succès !'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
        });
      }
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response != null && e.response?.data != null && e.response?.data['error'] != null) {
        errorMessage += e.response!.data['error'];
      } else {
        errorMessage += e.message!;
      }
      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la connexion : $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Event'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: "Entrer le code",
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        final code = _controller.text;
                        if (code.isNotEmpty) {
                          joinEvent(code);
                        } else {
                          setState(() {
                            _errorMessage = 'Le code ne peut pas être vide';
                          });
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Join'),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
