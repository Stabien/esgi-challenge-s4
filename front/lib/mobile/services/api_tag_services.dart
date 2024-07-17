import 'package:dio/dio.dart';
import 'package:mobile/mobile/models/tag.dart';
import 'package:mobile/web/utils/api_utils.dart';

class TagServices {
  static Future<List<Tag>> getTags() async {
    try {
      var response = await ApiUtils.get('/tags');

      if (response.statusCode == 200) {
        List<Tag> tags = [];

        if (response.data is List) {
          tags = (response.data as List)
              .map((item) => Tag.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return tags;
      } else {
        // print(
        //     'Erreur lors de la récupération des messages: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // print('Erreur inconnue dans getMessagesByEvent: $error');
      return [];
    }
  }

  Future<Response> postTag(payload) async {
    var response = await ApiUtils.post('/tag', payload);

    return response;
  }

  Future<Response> deleteTag(id) async {
    var response = await ApiUtils.delete('/tag/$id', {});

    return response;
  }
}
