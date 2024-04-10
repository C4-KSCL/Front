import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NickNameCheck {
  static Future<String?> checknickname(String nickname) async {
    final url = Uri.parse('http://15.164.245.62:8000/signup/checknickname');
    try {
      final response = await http.post(
        url,
        body: {'nickname': nickname},
      );

      if (response.statusCode == 200) {
        print('사용 가능한 닉네임입니다.');
      } else if (response.statusCode == 401) {
        print('이미 사용 중인 닉네임입니다.');
      } else {
        print('서버 에러가 발생했습니다. 에러 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('닉네임 확인 중 에러가 발생했습니다: $e');
    }
  }
}
