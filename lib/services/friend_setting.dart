import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config.dart';

class FriendSettingService {
  static Future<void> updateFriendMbtiSetting(
    String accessToken,
    String friendMBTI,
    String friendMaxAge,
    String friendMinAge,
    String friendGender,
  ) async {
    String? baseUrl=AppConfig.baseUrl;

    final url = Uri.parse('$baseUrl/findfriend/settingMBTI');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accesstoken': accessToken,
      },
      body: jsonEncode({
        'friendMBTI': friendMBTI,
        'friendMaxAge': friendMaxAge,
        'friendMinAge': friendMinAge,
        'friendGender': friendGender,
      }),
    );

    if (response.statusCode == 200) {
      print('친구mbti 변경 성공');
    } else {
      print('친구mbti 변경 실패: ${response.body} ${response.statusCode}');
    }
  }

  static Future<void> updateFriendKeywordSetting(
      String accessToken, String friendKeyword) async {
    late final String? baseUrl;
    baseUrl = dotenv.env['SERVER_URL'];

    final url = Uri.parse('$baseUrl/findfriend/settingKeyword');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accesstoken': accessToken,
      },
      body: jsonEncode({
        'friendKeyword': friendKeyword,
      }),
    );

    if (response.statusCode == 200) {
      print('친구키워드 변경 성공');
    } else {
      print('친구키워드 변경 실패: ${response.body} ${response.statusCode}');
    }
  }
}
