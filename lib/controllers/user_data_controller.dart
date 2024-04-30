import 'dart:convert';

import 'package:frontend_matching/controllers/chatting_list_controller.dart';
import 'package:frontend_matching/controllers/find_friend_controller.dart';
import 'package:frontend_matching/controllers/friend_controller.dart';
import 'package:frontend_matching/controllers/signupController.dart';
import 'package:frontend_matching/pages/login/loginPage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../pages/init_page.dart';
import '../models/user.dart';
import '../models/userImage.dart';

class UserDataController extends GetxController {
  static UserDataController get to => Get.find<UserDataController>();
  SignupController signupController = Get.find<SignupController>();
  Rxn<User?> user = Rxn<User?>(null);
  RxList<XFile?> userImages = <XFile?>[].obs;
  Rx<String> matchingUserNumbers="1,2,3".obs; // 매칭 친구 userNumbers

  List<dynamic> images = [];
  var accessToken = '';
  var refreshToken = '';

  static const baseUrl = 'http://15.164.245.62:8000';
  static const signup = 'signup';
  static const register = 'register';
  static const auth = 'auth';
  static const login = 'login';

  //컨트롤러가 준비되었을 때 실행 -> 초기화 작업이나 데이터 로딩과 같은 초기 설정
  @override
  void onReady() {
    super.onReady();
    _moveToPage(user.value);
    ever(user, _moveToPage); //user에 변화가 생기면 함수 실행
  }

  //유저를 새로 반환받음
  void updateUserInfo(User newUser) {
    user.value = newUser;
  }

  //User 정보에 따른 페이지 이동
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
    String data = '{"email": "$email", "password": "$password"}';

    final response = await http.post(url, headers: headers, body: data);

    if (response.statusCode == 200) {
      final loginUserData = jsonDecode(response.body);
      print(loginUserData);

      Get.put(UserDataController());
      UserDataController userDataController = Get.find();

      userDataController.user.value = User.fromJson(loginUserData['user']);

      userDataController.images = loginUserData['images']
          .map((data) => UserImage.fromJson(data))
          .toList();

      userDataController.accessToken = loginUserData['accessToken'];
      userDataController.refreshToken = loginUserData['refreshToken'];
      print('login success');
      print(loginUserData['accessToken']);
      print(loginUserData['refreshToken']);

      FindFriendController.findFriends();
      FriendController.getFriendList();
      FriendController.getFriendReceivedRequest();
      FriendController.getFriendSentRequest();
      ChattingListController.getLastChatList();
    } else {
      print('login fail');
    }
  }

  //로그아웃
  void logout() {
    user.value = null;
    signupController.resetAllInputs();
  }
}
