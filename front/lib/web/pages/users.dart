import 'package:flutter/material.dart';
import 'package:mobile/web/ui/appbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/mobile/utils/secureStorage.dart';

class WebUserPage extends StatelessWidget {
  const WebUserPage({super.key});

  Future<List<User>> fetchAllUsers() async {
    final dio = Dio();

    try {
      final token = await SecureStorage.getStorageItem('token');
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.connectTimeout = const Duration(milliseconds: 10000);

      final apiUrl = '${dotenv.env['URL_BACK']}/users';
      final response = await dio.get(apiUrl);
      final List<dynamic> jsonList = response.data;
      return jsonList
          .map((json) => User(
                id: json['ID'],
                email: json['Email'],
                role: json['Role'],
              ))
          .toList();
    } catch (error) {
      throw Exception('An error occurred while fetching all users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: FutureBuilder<List<User>>(
        future: fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data;
            return ListView.builder(
              itemCount: users?.length ?? 0,
              itemBuilder: (context, index) {
                final user = users![index];
                return ListTile(
                  title: Text(
                    "ID: ${user.id}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "Email: ${user.email}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Text(
                    "Role: ${user.role}",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class User {
  final String id;
  final String email;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.role,
  });
}
