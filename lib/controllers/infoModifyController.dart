import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoModifyController extends GetxController {
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
      String birthdate,
      String gender,
      String myMBTI,
      String myKeyword,
      String friendKeyword) async {
    final url = Uri.parse('http://15.164.245.62:8000/edit/info');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accesstoken': accessToken,
        'refreshtoken': refreshToken
      },
      body: jsonEncode({
        'password': password,
        'nickname': nickname,
        'phoneNumber': phoneNumber,
        'birthdate': birthdate,
        'gender': gender,
        'myMBTI': myMBTI,
        'myKeyword': myKeyword,
        'friendKeyword': friendKeyword,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      userInfo.value = User.fromJson(data);
      Get.find<UserDataController>().updateUserInfo(userInfo.value);
      print('개인정보 수정 성공');
    } else {
      print('개인정보 수정 오류 발생: ${response.statusCode}');
    }
  }
}