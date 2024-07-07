import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/models/message.dart';

class MessageServices {
  static final String baseUrl = dotenv.env['URL_BACK'].toString();
  final Dio dio = Dio(BaseOptions(
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  ));

  Future<List<Message>> getMessagesByEvent(String id) async {
    try {
      if (baseUrl == null) {
        throw Exception('BaseUrl is null');
      }

      final Response response = await Dio().get(
          '$baseUrl/messages/event/$id'); // Utilisation de Dio pour effectuer la requête GET
      print("la valeur est : ");
      print(response.data.toString());

      if (response.statusCode == 200) {
        // Vérifier que la requête a réussi
        List<Message> messages = []; // Initialiser une liste vide de messages

        // Vérifier que response.data est une liste
        if (response.data is List) {
          // Mapper chaque élément de la liste en un objet Message
          messages = (response.data as List)
              .map((item) => Message.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return messages; // Retourner la liste des messages
      } else {
        print(
            'Erreur lors de la récupération des messages: ${response.statusCode}');
        return []; // Retourner une liste vide si la requête a échoué
      }
    } catch (error) {
      print('Erreur inconnue dans getMessagesByEvent: $error');
      return []; // Retourner une liste vide en cas d'erreur
    }
  }

  Future<Response> postMessage(payload) async {
    Response response = await dio.post('$baseUrl/messages', data: {
      'date': payload.date,
      'sender': payload.sender,
      'organizerId': payload.organizerId,
      'eventId': payload.eventId,
      'text': payload.text,
    });

    return response;
  }
}
