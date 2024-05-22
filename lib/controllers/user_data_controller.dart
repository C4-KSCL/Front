import 'dart:convert';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:frontend_matching/services/fcm_token_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../pages/init_page.dart';
import '../models/user.dart';
import '../models/userImage.dart';

class UserDataController extends GetxController {
  static UserDataController get to => Get.find<UserDataController>();
  SignupController signupController = Get.find<SignupController>();
  Rxn<User?> user = Rxn<User?>(null);
  RxList<UserImage> images = <UserImage>[].obs;

  // Rx<String> matchingUserNumbers = "1,2,3".obs; // 매칭 유저 정보
  Rx<bool> isAutoLogin = true.obs; // 자동 로그인 여부

  var accessToken = '';
  var refreshToken = '';

  static const signup = 'signup';
  static const register = 'register';
  static const auth = 'auth';
  static const login = 'login';

  static String? baseUrl = AppConfig.baseUrl;

  void updateTokens(String newAccessToken, String newRefreshToken) {
    // 토큰 갱신 시 사용함
    accessToken = newAccessToken;
    refreshToken = newRefreshToken;
  }

  void updateUserInfo(User newUser) {
    user.value = newUser;
  }

  void updateImageInfo(List<UserImage> newImages) {
    images.assignAll(newImages);
  }

  static Future<void> loginUser(String email, String password) async {
    AppConfig.putGetxControllerDependency();
    final url = Uri.parse('$baseUrl/$auth/$login');

    Map<String, String> headers = {"Content-type": "application/json"};
    final body = jsonEncode({"email": email, "password": password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // 자동 로그인 관련 처리
      if (UserDataController.to.isAutoLogin.value) {
        // 아이디 비번 저장
        await AppConfig.storage.write(key: "autoLoginEmail", value: email);
        await AppConfig.storage.write(key: "autoLoginPw", value: password);
        await AppConfig.storage.write(key: "isAutoLogin", value: "true");
      } else {
        await AppConfig.storage.write(key: "autoLoginEmail", value: '');
        await AppConfig.storage.write(key: "autoLoginPw", value: '');
        await AppConfig.storage.write(key: "isAutoLogin", value: "false");
      }

      FcmService.requestPermission();

      final loginUserData = jsonDecode(response.body);
      print(loginUserData);

      UserDataController.to.user.value = User.fromJson(loginUserData['user']);

      List<UserImage> images = (loginUserData['images'] as List)
          .map((data) => UserImage.fromJson(data as Map<String, dynamic>))
          .toList();

      UserDataController.to.updateImageInfo(images);

      UserDataController.to.accessToken = loginUserData['accessToken'];
      UserDataController.to.refreshToken = loginUserData['refreshToken'];
      print('login success');
      print(loginUserData['accessToken']);
      print(loginUserData['refreshToken']);

      await FindFriendController.findFriends();
      await FriendController.getFriendList();
      await FriendController.getFriendReceivedRequest();
      await FriendController.getFriendSentRequest();
      await ChattingListController.getLastChatList();
      Get.offAll(() => const InitPage());
    } else {
      print('login fail');
    }
  }

  void logout() async {
    user.value = null;
    accessToken = '';
    refreshToken = '';
    signupController.resetAllInputs();
    FriendController.to.resetData();
    ChattingListController.to.resetData();
    ////////////////수정 필요 //////////////////////////
    await FcmService.deleteUserFcmToken();
    await AppConfig.storage.write(key: "isAutoLogin", value: "false");

    Get.offNamed('/login');
    // Get.delete<FriendController>();
    // Get.delete<ChattingListController>();
    // Get.put(FriendController());
    // Get.put(ChattingListController());
    user.value = null;
    images.value = <UserImage>[].obs;
    isAutoLogin.value = false;

    print("로그아웃");
  }

  static Future<http.Response> getRequest({
    required Uri url,
    required String accessToken,
  }) async {
    return await http.get(
      url,
      headers: {
        "Content-type": "application/json",
        "accessToken": accessToken,
      },
    );
  }

  static Future<http.Response> getRequestWithRefreshToken({
    required Uri url,
    required String accessToken,
    required String refreshToken,
  }) async {
    return await http.get(
      url,
      headers: {
        "Content-type": "application/json",
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      },
    );
  }

  static Future<http.Response> deleteRequest({
    required Uri url,
    required String accessToken,
  }) async {
    return await http.delete(
      url,
      headers: {
        "Content-type": "application/json",
        "accessToken": accessToken,
      },
    );
  }

  static Future<http.Response> deleteRequestWithRefreshToken({
    required Uri url,
    required String accessToken,
    required String refreshToken,
  }) async {
    return await http.delete(
      url,
      headers: {
        "Content-type": "application/json",
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      },
    );
  }

  static Future<http.Response> patchRequest({
    required Uri url,
    required String accessToken,
    String? body,
  }) async {
    if (body == null) {
      return await http.patch(
        url,
        headers: {
          "Content-type": "application/json",
          "accessToken": accessToken,
        },
      );
    } else {
      return await http.patch(
        url,
        headers: {
          "Content-type": "application/json",
          "accessToken": accessToken,
        },
        body: body,
      );
    }
  }

  static Future<http.Response> patchRequestWithRefreshToken({
    required Uri url,
    required String accessToken,
    required String refreshToken,
    String? body,
  }) async {
    if (body == null) {
      return await http.patch(
        url,
        headers: {
          "Content-type": "application/json",
          "accessToken": accessToken,
        },
      );
    } else {
      return await http.patch(
        url,
        headers: {
          "Content-type": "application/json",
          "accessToken": accessToken,
        },
        body: body,
      );
    }
  }

  static Future<http.Response> postRequest({
    required Uri url,
    required String accessToken,
    required String body,
  }) async {
    return await http.post(
      url,
      headers: {
        "Content-type": "application/json",
        "accessToken": accessToken,
      },
      body: body,
    );
  }

  static Future<http.Response> postRequestWithRefreshToken({
    required Uri url,
    required String accessToken,
    required String refreshToken,
    required String body,
  }) async {
    return await http.post(
      url,
      headers: {
        "Content-type": "application/json",
        "accessToken": accessToken,
      },
      body: body,
    );
  }
}
