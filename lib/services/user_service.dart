import 'dart:convert';
import 'package:frontend_matching/controllers/userDataController.dart';
import 'package:frontend_matching/models/userImage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserServices {
  static const baseUrl = 'http://15.164.245.62:8000';
  static const signup = 'signup';
  static const register = 'register';
  static const auth = 'auth';
  static const login = 'login';

  static Map<String, String> jsonHeaders = {"Content-type": "application/json"};
  UserDataController userDataController = Get.find<UserDataController>();

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
    } else {
      print('login fail');
    }
  }
}
