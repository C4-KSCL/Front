import 'package:http/http.dart' as http;
import 'dart:convert';

class FriendSettingService {
  Future<void> updateFriendSetting(
    String accessToken,
    String friendMBTI,
    String friendMaxAge,
    String friendMinAge,
    String friendGender,
  ) async {
    final url = Uri.parse('https://soulmbti.shop:8000/findfriend/setting');
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
      print('친구설정 변경 성공');
    } else {
      print('친구설정 변경 실패: ${response.body} ${response.statusCode}');
    }
  }
}
