import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/mobile/models/message.dart';

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

      final Response response = await Dio().get('$baseUrl/messages/event/$id');

      if (response.statusCode == 200) {
        List<Message> messages = [];

        if (response.data is List) {
          messages = (response.data as List)
              .map((item) => Message.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return messages;
      } else {
        print(
            'Erreur lors de la récupération des messages: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Erreur inconnue dans getMessagesByEvent: $error');
      return [];
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
