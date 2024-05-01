import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoModifyController extends GetxController {
  static late final String? baseUrl;

  @override
  void onInit() async {
    super.onInit();
    baseUrl = dotenv.env['SERVER_URL'];
  }

  Rx<User> userInfo = User(
    email: '',
    password: '',
    nickname: '',
    phoneNumber: '',
    age: '',
    gender: '',
    myMBTI: '',
    myKeyword: '',
    friendKeyword: '',
    userNumber: 0,
  ).obs;

  Future<void> InfoModify(
    String accessToken,
    String refreshToken,
    String password,
    String nickname,
    String phoneNumber,
    String age,
    String gender,
    String myMBTI,
    String myKeyword,
    String friendKeyword,
  ) async {
    final url = Uri.parse('$baseUrl/edit/info');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accessToken': accessToken,
        'refreshToken': refreshToken
      },
      body: jsonEncode({
        'password': password,
        'nickname': nickname,
        'phoneNumber': phoneNumber,
        'age': age,
        'gender': gender,
        'myMBTI': myMBTI,
        'myKeyword': myKeyword,
        'friendKeyword': friendKeyword,
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
}
