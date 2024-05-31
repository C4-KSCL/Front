import 'package:flutter/material.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config.dart';

class FindFriendController extends GetxController {
  static FindFriendController get to => Get.find();

  static String? baseUrl = AppConfig.baseUrl;

  RxList<User> matchingFriendInfoList = RxList<User>();
  RxList<List<UserImage>> matchingFriendImageList = RxList<List<UserImage>>();

  static Future<void> findFriends() async {
    final url = Uri.parse('$baseUrl/findfriend/friend-matching');
    Get.put(UserDataController());
    UserDataController userDataController = Get.find();

    // matchingFriendList 비우기
    FindFriendController.to.matchingFriendImageList.clear();
    FindFriendController.to.matchingFriendInfoList.clear();

    var response = await _getRequest(url, userDataController.accessToken);

    if (response.statusCode == 401) {
      // AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도
      print("AccessToken이 만료된 경우, RefreshToken을 사용하여 갱신 시도");
      print(response.body);
      response = await _getRequestWithRefreshToken(
        url,
        userDataController.accessToken,
        userDataController.refreshToken,
      );

      if (response.statusCode == 300) {
        // 새로운 토큰을 받아서 갱신 후 요청
        print("새로운 토큰을 받아서 갱신 및 요청");
        print(response.body);

        final newTokens = jsonDecode(response.body);
        userDataController.updateTokens(
            newTokens['accessToken'], newTokens['refreshToken']);

        response = await _getRequest(url, newTokens['accessToken']);
      } else if (response.statusCode == 402) {
        // RefreshToken도 만료된 경우
        print('리프레시 토큰 만료, 재로그인');
        print(response.body);
        Get.snackbar('실패', '로그인이 필요합니다.');
        userDataController.logout();
        return;
      }
    }

    if (response.statusCode == 200) {
      final friendsData = jsonDecode(response.body);
      print('check');
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
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('시간 제한'),
            content: const Text('아직 다음 매칭시간이 남았습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 404) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('친구 없음'),
            content: const Text('해당하는 친구가 더 존재하지 않습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    } else {
      print('${response.statusCode} ${response.body}');
    }
  }

  static Future<http.Response> _getRequest(
    Uri url,
    String accessToken,
  ) async {
    return await http.get(
      url,
      headers: {
        "Content-type": "application/json",
        "accessToken": accessToken,
      },
    );
  }

  static Future<http.Response> _getRequestWithRefreshToken(
    Uri url,
    String accessToken,
    String refreshToken,
  ) async {
    return await http.get(
      url,
      headers: {
        "Content-type": "application/json",
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      },
    );
  }
}
