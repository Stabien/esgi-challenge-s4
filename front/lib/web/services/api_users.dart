import 'dart:convert';
import 'package:mobile/web/utils/api_utils.dart';

class UserService {
  Future<List<dynamic>> getAllUsers() async {
    var response = await ApiUtils.get('/users');

    if (response.statusCode == 200) {
      return json.decode(response.data);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<Map<String, dynamic>> getUser(String id) async {
    var response = await ApiUtils.get('/users/$id');

    if (response.statusCode == 200) {
      return json.decode(response.data);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> user) async {
    var response = await ApiUtils.post('/users', user);
    if (response.statusCode == 201) {
      return json.decode(response.data);
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String id, Map<String, dynamic> user) async {
    var response = await ApiUtils.patch('/users/$id', user);

    if (response.statusCode == 200) {
      return json.decode(response.data);
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String id) async {
    var response = await ApiUtils.delete('/users/$id', {});

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
