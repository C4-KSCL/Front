import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config.dart';

class FindFriendController extends GetxController {
  static FindFriendController get to => Get.find();

  static String? baseUrl=AppConfig.baseUrl;

  RxList<User> matchingFriendInfoList = RxList<User>();
  RxList<List<UserImage>> matchingFriendImageList = RxList<List<UserImage>>();

  static Future<void> findFriends() async {
    final url = Uri.parse('$baseUrl/findfriend/friend-matching');
    Get.put(UserDataController());
    UserDataController userDataController = Get.find();

    // matchingFriendList 비우기
    FindFriendController.to.matchingFriendImageList.clear();
    FindFriendController.to.matchingFriendInfoList.clear();

    // 헤더
    Map<String, String> headers = {
      "Content-type": "application/json",
      "accessToken": UserDataController.to.accessToken
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final friendsData = jsonDecode(response.body);
      print(friendsData['users']);
      print(friendsData['images']);

      // users 배열을 User 객체의 리스트로 변환
      List<User> users =
          List.from(friendsData['users'].map((data) => User.fromJson(data)));

      for (User user in users) {
        FindFriendController.to.matchingFriendInfoList.add(user);
        List<UserImage> images = [];
        if (friendsData['images'] != null) {
          List<UserImage> userImages = List.from(
              friendsData['images'].map((data) => UserImage.fromJson(data)));
          for (var userImage in userImages) {
            if (user.userNumber == userImage.userNumber) {
              images.add(userImage);
            }
          }
        }
        FindFriendController.to.matchingFriendImageList.add(images);
      }
    } else if (response.statusCode == 400) {
      print(response.statusCode);
    } else {
      print('${response.statusCode} ${response.body}');
    }
  }
}
