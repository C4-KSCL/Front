import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/pages/signup/imageUpload/selectImagePage.dart';
import 'package:http/http.dart' as http;

class DeleteUser {
  static Future<void> deleteUser(String accesstoken) async {
    late final String? baseUrl;

    baseUrl = dotenv.env['SERVER_URL'];
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete/user'),
        headers: {
          'accesstoken': accesstoken,
        },
      );

      if (response.statusCode == 200) {
        print('정상적으로 삭제됨');
        userDataController.logout();
      } else {
        print('실패 : Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('오류발생 : $e');
    }
  }
}
