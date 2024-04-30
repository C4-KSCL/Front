import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class UserProfileController extends GetxController {
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
  var profileImageUrl = ''.obs; // 사용자 프로필 이미지 URL을 관리하는 Observable 변수
  UserDataController userDataController = Get.find<UserDataController>();

  void setProfileImageUrl(String url) {
    profileImageUrl.value = url; // 프로필 이미지 URL 업데이트
  }

  Future<void> deleteProfileImage(String accessToken, String deletePath) async {
    final url = Uri.parse('http://15.164.245.62:8000/edit/deleteprofile');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accesstoken': accessToken,
      },
      body: jsonEncode({'deletepath': deletePath}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      userInfo.value = User.fromJson(data['user']);
      Get.find<UserDataController>().updateUserInfo(userInfo.value);
      print('삭제 성공');
    } else {
      print('오류 발생: ${response.statusCode}');
    }
  }

  Future<void> uploadProfileImage(String accessToken) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://15.164.245.62:8000/edit/addprofile'))
        ..headers['accesstoken'] = accessToken
        ..files.add(await http.MultipartFile.fromPath(
          'files',
          pickedFile.path,
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        // StreamedResponse를 Response 객체로 변환
        final respBody = await http.Response.fromStream(response);
        final data = jsonDecode(respBody.body);
        userInfo.value = User.fromJson(data['user']);
        Get.find<UserDataController>().updateUserInfo(userInfo.value);
        print('이미지 저장 성공');
      } else {
        print('이미지 저장 실패: ${response.statusCode}');
      }
    }
  }
}
