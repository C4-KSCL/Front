import 'dart:convert';

import 'package:frontend_matching/models/matching.dart';
import 'package:http/http.dart' as http;

class MatchingService {
  static Future<void> fetchFriendMatching(String accessToken) async {
    const String url = 'http://15.164.245.62:8000/findfriend/friend-matching';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accesstoken': accessToken,
        },
      );

      switch (response.statusCode) {
        case 200:
          final data = parseData(response.body);
          print('//////////////////////');
          print(response.body);
          print(
              "매칭 성공: ${data.users.length}명의 사용자와 ${data.images.length}개의 이미지가 반환됨.");
          break;
        case 400:
          final responseBody = json.decode(response.body);
          print("매칭 시간 제한: 최근 요청 시간 - ${responseBody['requestTime']}");
          break;
        case 401:
          print("해당 친구 없음");
          break;
        case 500:
          print("매칭 실패(서버 에러)");
          break;
        default:
          print("예상치 못한 응답: ${response.statusCode}");
          break;
      }
    } catch (e) {
      print("API 호출 중 오류 발생: $e");
    }
  }
}
