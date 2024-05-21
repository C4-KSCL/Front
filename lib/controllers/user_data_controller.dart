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
  Rx<bool> isAutoLogin=true.obs; // 자동 로그인 여부

  var accessToken = '';
  var refreshToken = '';

  static const signup = 'signup';
  static const register = 'register';
  static const auth = 'auth';
  static const login = 'login';

  static String? baseUrl=AppConfig.baseUrl;

  // @override
  // void onReady() {
  //   super.onReady();
  //   _moveToPage(user.value);
  //   ever(user, _moveToPage);
  // }
  // void _moveToPage(User? user) {
  //   if (user == null) {
  //     Get.offAll(() => LoginPage());
  //   } else {
  //     Get.offAll(() => InitPage());
  //   }
  // }

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
      if(UserDataController.to.isAutoLogin.value){
        // 아이디 비번 저장
        await AppConfig.storage.write(key: "autoLoginEmail", value: email);
        await AppConfig.storage.write(key: "autoLoginPw", value: password);
        await AppConfig.storage.write(key: "isAutoLogin", value: "true");
      }
      else{
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
      Get.offAll(()=>const InitPage());
    } else {
      print('login fail');
    }
  }

  void logout() async {
    ////////////////수정 필요 //////////////////////////
    await FcmService.deleteUserFcmToken();
    Get.offNamed('/login');
    // Get.delete<FriendController>();
    // Get.delete<ChattingListController>();
    // Get.put(FriendController());
    // Get.put(ChattingListController());
    user.value=null;
    images.value=<UserImage>[].obs;
    isAutoLogin.value=false;

    print("로그아웃");
  }
}
