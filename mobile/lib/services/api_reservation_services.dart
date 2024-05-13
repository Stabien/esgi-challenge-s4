import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> reserveEvent(String eventId, String customerID) async {
  try {
    Dio dio = Dio();
    String url = '${dotenv.env['URL_BACK']}/reservations';

    Map<String, dynamic> data = {
      'eventID': eventId,
      'customerID': customerID,
    };

    Response response = await dio.post(url, data: data);

    print(response.data);
  } catch (error) {
    print('Erreur lors de la réservation de l\'événement: $error');
  }
}
