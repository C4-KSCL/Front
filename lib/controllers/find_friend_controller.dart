import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/user.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:frontend_matching/pages/init_page.dart';
import 'package:frontend_matching/pages/matching/mainPage.dart';
import 'package:frontend_matching/pages/matching/mbtiSettingPage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config.dart';

List<User> users = [];

class FindFriendController extends GetxController {
  static FindFriendController get to => Get.find();

  static String? baseUrl = AppConfig.baseUrl;

  RxList<User> matchingFriendInfoList = RxList<User>();
  RxList<List<UserImage>> matchingFriendImageList = RxList<List<UserImage>>();
  RxList<List<UserImage>> previousFriendImageList = RxList<List<UserImage>>();

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
      users =
          List.from(friendsData['users'].map((data) => User.fromJson(data)));
      FindFriendController.to.previousFriendImageList.clear();
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
        FindFriendController.to.previousFriendImageList.add(images);
      }
    } else if (response.statusCode == 400) {
      _showErrorDialog(
        title: '시간 제한',
        content: '아직 다음 매칭시간이 남았습니다.',
      );
    } else if (response.statusCode == 404) {
      _showErrorDialog(
        title: '친구 없음',
        content: '해당하는 친구가 더 존재하지 않습니다.',
      );
    } else {
      print('${response.statusCode} ${response.body}');
    }
  }

  static Future<void> _showErrorDialog({
    required String title,
    required String content,
  }) async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                for (User user in users) {
                  FindFriendController.to.matchingFriendInfoList.add(user);
                }
                FindFriendController.to.matchingFriendImageList
                    .addAll(FindFriendController.to.previousFriendImageList);
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
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
