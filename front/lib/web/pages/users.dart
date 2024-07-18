import 'package:flutter/material.dart';
import 'package:mobile/web/ui/appbar.dart';
import 'package:mobile/web/utils/api_utils.dart';

class WebUserPage extends StatelessWidget {
  const WebUserPage({super.key});

  Future<List<User>> fetchAllUsers() async {
    try {
      final response = await ApiUtils.get('/users');
      final List<dynamic> jsonList = response.data;
      return jsonList
          .map((json) => User(
                id: json['ID'],
                email: json['Email'],
                role: json['Role'],
                firstname:
                    json['Customers'] != null && json['Customers'].isNotEmpty
                        ? json['Customers'][0]['Firstname']
                        : json['Organizers'] != null &&
                                json['Organizers'].isNotEmpty
                            ? json['Organizers'][0]['Firstname']
                            : "Admin",
                lastname:
                    json['Customers'] != null && json['Customers'].isNotEmpty
                        ? json['Customers'][0]['Lastname']
                        : json['Organizers'] != null &&
                                json['Organizers'].isNotEmpty
                            ? json['Organizers'][0]['Lastname']
                            : "account",
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
                    "${user.firstname ?? ''} ${user.lastname ?? ''}"
                    '\n'
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
  final String? firstname;
  final String? lastname;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.firstname,
    this.lastname,
  });
}
