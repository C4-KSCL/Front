import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class UserImageController extends GetxController {
  static late final String? baseUrl;

  @override
  void onInit() async {
    super.onInit();
    baseUrl = dotenv.env['SERVER_URL'];
  } // 이미지를 삭제하는 함수

  Rx<UserImage> newImage = UserImage(
          imageNumber: 0,
          userNumber: 0,
          imagePath: '',
          imageCreated: DateTime.now(),
          imageKey: '')
      .obs;

  UserDataController userDataController = Get.find<UserDataController>();

  //이미지 삭제
  Future<void> deleteImage(int index, String accessToken) async {
    final img = userDataController.images[index];
    final url = Uri.parse('$baseUrl/edit/deleteimage');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'accessToken': accessToken
          },
          body: jsonEncode({'deletepath': img.imagePath}));

      if (response.statusCode == 200) {
        print('삭제 성공: ${response.body}');
        userDataController.images.removeAt(index);
        Get.snackbar('삭제 성공', '이미지가 성공적으로 삭제되었습니다.');
      } else {
        print('삭제 실패: ${response.statusCode}');
        Get.snackbar('삭제 실패', '이미지 삭제에 실패했습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
      Get.snackbar('오류', '오류가 발생했습니다: $e');
    }
  }

  // 이미지 수정
  Future<void> addImage(XFile pickedFile, String accessToken) async {
    final url = Uri.parse('$baseUrl/edit/addimage');
    var request = http.MultipartRequest('POST', url);
    request.headers['accesstoken'] = accessToken;
    request.files
        .add(await http.MultipartFile.fromPath('files', pickedFile.path));

    try {
      var response = await http.Client().send(request);
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('이미지 추가 완료');
        final newUserData = jsonDecode(responseBody);
        userDataController.images = newUserData['images']
            .map((data) => UserImage.fromJson(data))
            .toList();
        Get.snackbar('성공', '이미지가 성공적으로 추가되었습니다.');
      } else {
        print('이미지 추가 실패: ${response.statusCode}');
        Get.snackbar('실패', '이미지 추가에 실패했습니다.');
      }
    } catch (e) {
      print('오류 발생: $e');
      Get.snackbar('오류', '오류가 발생했습니다: $e');
    }
  }
}
