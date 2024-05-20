import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config.dart';

class InfoModifyController extends GetxController {
  static String? baseUrl=AppConfig.baseUrl;

  Rx<User> userInfo = User(
    email: '',
    password: '',
    nickname: '',
    phoneNumber: '',
    age: '',
    gender: '',
    userNumber: 0,
  ).obs;

  Future<void> InfoModify(
    String accessToken,
    String password,
    String nickname,
    String phoneNumber,
    String age,
  ) async {
    final url = Uri.parse('$baseUrl/edit/info');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'accessToken': accessToken},
      body: jsonEncode({
        'password': password,
        'nickname': nickname,
        'phoneNumber': phoneNumber,
        'age': age,
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      userInfo.value = User.fromJson(data['user']);
      Get.find<UserDataController>().updateUserInfo(userInfo.value);
      print('개인정보 수정 성공');
    } else {
      print('개인정보 수정 오류 발생: ${response.statusCode}');
    }
  }

  Future<void> MbtiModify(String accessToken, String myMBTI) async {
    final url = Uri.parse('$baseUrl/edit/infoMBTI');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'accessToken': accessToken},
      body: jsonEncode({
        'myMBTI': myMBTI,
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      userInfo.value = User.fromJson(data['user']);
      Get.find<UserDataController>().updateUserInfo(userInfo.value);
      print('MBTI 수정 성공');
    } else {
      print('MBTI 수정 오류 발생: ${response.statusCode}');
    }
  }

  Future<void> KeywordModify(String accessToken, String myKeyword) async {
    final url = Uri.parse('$baseUrl/edit/infoKeyword');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'accessToken': accessToken},
      body: jsonEncode({
        'myKeyword': myKeyword,
      }),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      userInfo.value = User.fromJson(data['user']);
      Get.find<UserDataController>().updateUserInfo(userInfo.value);
      print('Keyword 수정 성공');
    } else {
      print('Keyword 수정 오류 발생: ${response.statusCode}');
    }
  }
}
