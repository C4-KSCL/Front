import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:frontend_matching/services/fcm_token_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../pages/init_page.dart';
import '../models/user.dart';
import '../models/userImage.dart';

class UserDataController extends GetxController {
  static UserDataController get to => Get.find<UserDataController>();
  SignupController signupController = Get.find<SignupController>();
  Rxn<User?> user = Rxn<User?>(null);
  RxList<UserImage> images = <UserImage>[].obs;
  Rx<String> matchingUserNumbers = "1,2,3".obs;

  var accessToken = '';
  var refreshToken = '';

  static const signup = 'signup';
  static const register = 'register';
  static const auth = 'auth';
  static const login = 'login';

  static late final String? baseUrl;

  @override
  void onInit() async {
    super.onInit();
    baseUrl = dotenv.env['SERVER_URL'];
  }

  @override
  void onReady() {
    super.onReady();
    _moveToPage(user.value);
    ever(user, _moveToPage);
  }

  void updateUserInfo(User newUser) {
    user.value = newUser;
  }

  void updateImageInfo(List<UserImage> newImages) {
    images.assignAll(newImages);
  }

  void _moveToPage(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => InitPage());
    }
  }

  static void loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/$auth/$login');

    Map<String, String> headers = {"Content-type": "application/json"};
    final body = jsonEncode({"email": email, "password": password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      FcmService.requestPermission();

      final loginUserData = jsonDecode(response.body);
      print(loginUserData);

      Get.put(UserDataController());
      UserDataController userDataController = Get.find();

      userDataController.user.value = User.fromJson(loginUserData['user']);

      List<UserImage> images = (loginUserData['images'] as List)
          .map((data) => UserImage.fromJson(data as Map<String, dynamic>))
          .toList();

      userDataController.updateImageInfo(images);

      userDataController.accessToken = loginUserData['accessToken'];
      userDataController.refreshToken = loginUserData['refreshToken'];
      print('login success');
      print(loginUserData['accessToken']);
      print(loginUserData['refreshToken']);

      await FindFriendController.findFriends();
      await FriendController.getFriendList();
      await FriendController.getFriendReceivedRequest();
      await FriendController.getFriendSentRequest();
      await ChattingListController.getLastChatList();
    } else {
      print('login fail');
    }
  }

  void logout() {
    user.value = null;
    signupController.resetAllInputs();
    FriendController.to.resetData();
    ChattingListController.to.resetData();
  }
}
