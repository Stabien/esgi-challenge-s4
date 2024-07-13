import 'package:flutter/material.dart';

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
}
