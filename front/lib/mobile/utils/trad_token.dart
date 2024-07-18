import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/mobile/utils/secure_storage.dart';

String jwtSecret = '${dotenv.env['JWT_SECRET']}';

Future<void> verifyAndDecodeJwt(String token) async {
  try {
    final jwt = JWT.verify(token, SecretKey(jwtSecret));

    final id = jwt.payload['id'];
    final email = jwt.payload['email'];
    final role = jwt.payload['role'];

    await SecureStorage.addStorageItem('userId', id);
    await SecureStorage.addStorageItem('userEmail', email);
    await SecureStorage.addStorageItem('userRole', role);
  } catch (e) {
    // print('Erreur de vérification du jeton: $e');
  }
}
