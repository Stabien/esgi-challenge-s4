import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mobile/mobile/utils/secureStorage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  bool _isLoggedIn = false;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
  }

  void logout() {
    _isLoggedIn = false;
  }

  Future<bool> verifyAndDecodeJwt(String token) async {
    try {
      JWT.verify(token, SecretKey('${dotenv.env['JWT_SECRET']}'));
      return true;
    } catch (e) {
      await SecureStorage.deleteStorageItem('token');
      return false;
    }
  }
}
