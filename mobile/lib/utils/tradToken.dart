import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/utils/secureStorage.dart';



String jwtSecret = '${dotenv.env['JWT_SECRET']}';

Future<void> verifyAndDecodeJwt(String token) async {

  try {
    final jwt = JWT.verify(token, SecretKey(jwtSecret));
    
    final id = jwt.payload['id'];
    final email = jwt.payload['email'];

    print('UserID: $id');
    await SecureStorage.addStorageItem('userId', id);

    print('UserEmail: $email');
    await SecureStorage.addStorageItem('userEmail', email);
    



  } catch (e) {
    // Gérez les erreurs de vérification
    print('Erreur de vérification du jeton: $e');
  }
}
